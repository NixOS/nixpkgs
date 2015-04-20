{ config, lib, pkgs }:

with lib;

let cfg = config.systemd; in

rec {

  shellEscape = s: (replaceChars [ "\\" ] [ "\\\\" ] s);

  makeUnit = name: unit:
    let
      pathSafeName = lib.replaceChars ["@" ":" "\\"] ["-" "-" "-"] name;
    in
    if unit.enable then
      pkgs.runCommand "unit-${pathSafeName}" { preferLocalBuild = true; inherit (unit) text; }
        ''
          mkdir -p $out
          echo -n "$text" > $out/${shellEscape name}
        ''
    else
      pkgs.runCommand "unit-${pathSafeName}-disabled" { preferLocalBuild = true; }
        ''
          mkdir -p $out
          ln -s /dev/null $out/${shellEscape name}
        '';

  generateUnits = type: units: upstreamUnits: upstreamWants:
    pkgs.runCommand "${type}-units" { preferLocalBuild = true; } ''
      mkdir -p $out

      # Copy the upstream systemd units we're interested in.
      for i in ${toString upstreamUnits}; do
        fn=${cfg.package}/example/systemd/${type}/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        if [ -L $fn ]; then
          target="$(readlink "$fn")"
          if [ ''${target:0:3} = ../ ]; then
            ln -s "$(readlink -f "$fn")" $out/
          else
            cp -pd $fn $out/
          fi
        else
          ln -s $fn $out/
        fi
      done

      # Copy .wants links, but only those that point to units that
      # we're interested in.
      for i in ${toString upstreamWants}; do
        fn=${cfg.package}/example/systemd/${type}/$i
        if ! [ -e $fn ]; then echo "missing $fn"; false; fi
        x=$out/$(basename $fn)
        mkdir $x
        for i in $fn/*; do
          y=$x/$(basename $i)
          cp -pd $i $y
          if ! [ -e $y ]; then rm $y; fi
        done
      done

      # Symlink all units provided listed in systemd.packages.
      for i in ${toString cfg.packages}; do
        for fn in $i/etc/systemd/${type}/* $i/lib/systemd/${type}/*; do
          if ! [[ "$fn" =~ .wants$ ]]; then
            ln -s $fn $out/
          fi
        done
      done

      # Symlink all units defined by systemd.units. If these are also
      # provided by systemd or systemd.packages, then add them as
      # <unit-name>.d/overrides.conf, which makes them extend the
      # upstream unit.
      for i in ${toString (mapAttrsToList (n: v: v.unit) units)}; do
        fn=$(basename $i/*)
        if [ -e $out/$fn ]; then
          if [ "$(readlink -f $i/$fn)" = /dev/null ]; then
            ln -sfn /dev/null $out/$fn
          else
            mkdir $out/$fn.d
            ln -s $i/$fn $out/$fn.d/overrides.conf
          fi
       else
          ln -fs $i/$fn $out/
        fi
      done

      # Created .wants and .requires symlinks from the wantedBy and
      # requiredBy options.
      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.wants'
            ln -sfn '../${name}' $out/'${name2}.wants'/
          '') unit.wantedBy) units)}

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.requires'
            ln -sfn '../${name}' $out/'${name2}.requires'/
          '') unit.requiredBy) units)}

      ${optionalString (type == "system") ''
        # Stupid misc. symlinks.
        ln -s ${cfg.defaultUnit} $out/default.target

        ln -s rescue.target $out/kbrequest.target

        mkdir -p $out/getty.target.wants/
        ln -s ../autovt@tty1.service $out/getty.target.wants/

        ln -s ../local-fs.target ../remote-fs.target ../network.target \
        ../nss-lookup.target ../nss-user-lookup.target ../swap.target \
        $out/multi-user.target.wants/
      ''}
    ''; # */

}
