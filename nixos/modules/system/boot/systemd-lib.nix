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
      pkgs.runCommand "unit-${pathSafeName}"
        { preferLocalBuild = true;
          allowSubstitutes = false;
          inherit (unit) text;
        }
        ''
          mkdir -p $out
          echo -n "$text" > $out/${shellEscape name}
        ''
    else
      pkgs.runCommand "unit-${pathSafeName}-disabled"
        { preferLocalBuild = true;
          allowSubstitutes = false;
        }
        ''
          mkdir -p $out
          ln -s /dev/null $out/${shellEscape name}
        '';

  boolValues = [true false "yes" "no"];

  digits = map toString (range 0 9);

  isByteFormat = s:
    let
      l = reverseList (stringToCharacters s);
      suffix = head l;
      nums = tail l;
    in elem suffix (["K" "M" "G" "T"] ++ digits)
      && all (num: elem num digits) nums;

  assertByteFormat = name: group: attr:
    optional (attr ? ${name} && ! isByteFormat attr.${name})
      "Systemd ${group} field `${name}' must be in byte format [0-9]+[KMGT].";

  hexChars = stringToCharacters "0123456789abcdefABCDEF";

  isMacAddress = s: stringLength s == 17
    && flip all (splitString ":" s) (bytes:
      all (byte: elem byte hexChars) (stringToCharacters bytes)
    );

  assertMacAddress = name: group: attr:
    optional (attr ? ${name} && ! isMacAddress attr.${name})
      "Systemd ${group} field `${name}' must be a valid mac address.";


  assertValueOneOf = name: values: group: attr:
    optional (attr ? ${name} && !elem attr.${name} values)
      "Systemd ${group} field `${name}' cannot have value `${attr.${name}}'.";

  assertHasField = name: group: attr:
    optional (!(attr ? ${name}))
      "Systemd ${group} field `${name}' must exist.";

  assertRange = name: min: max: group: attr:
    optional (attr ? ${name} && !(min <= attr.${name} && max >= attr.${name}))
      "Systemd ${group} field `${name}' is outside the range [${toString min},${toString max}]";

  assertOnlyFields = fields: group: attr:
    let badFields = filter (name: ! elem name fields) (attrNames attr); in
    optional (badFields != [ ])
      "Systemd ${group} has extra fields [${concatStringsSep " " badFields}].";

  checkUnitConfig = group: checks: v:
    let errors = concatMap (c: c group v) checks; in
    if errors == [] then true
      else builtins.trace (concatStringsSep "\n" errors) false;

  toOption = x:
    if x == true then "true"
    else if x == false then "false"
    else toString x;

  attrsToSection = as:
    concatStrings (concatLists (mapAttrsToList (name: value:
      map (x: ''
          ${name}=${toOption x}
        '')
        (if isList value then value else [value]))
        as));

  generateUnits = type: units: upstreamUnits: upstreamWants:
    pkgs.runCommand "${type}-units"
      { preferLocalBuild = true;
        allowSubstitutes = false;
      } ''
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
        ln -s ${cfg.ctrlAltDelUnit} $out/ctrl-alt-del.target
        ln -s rescue.target $out/kbrequest.target

        mkdir -p $out/getty.target.wants/
        ln -s ../autovt@tty1.service $out/getty.target.wants/

        ln -s ../local-fs.target ../remote-fs.target ../network.target \
        ../nss-lookup.target ../nss-user-lookup.target ../swap.target \
        $out/multi-user.target.wants/
      ''}
    ''; # */

}
