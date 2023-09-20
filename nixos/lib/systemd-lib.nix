{ config, lib, pkgs }:

with lib;

let
  cfg = config.systemd;
  lndir = "${pkgs.buildPackages.xorg.lndir}/bin/lndir";
  systemd = cfg.package;
in rec {

  shellEscape = s: (replaceStrings [ "\\" ] [ "\\\\" ] s);

  mkPathSafeName = lib.replaceStrings ["@" ":" "\\" "[" "]"] ["-" "-" "-" "" ""];

  # a type for options that take a unit name
  unitNameType = types.strMatching "[a-zA-Z0-9@%:_.\\-]+[.](service|socket|device|mount|automount|swap|target|path|timer|scope|slice)";

  makeUnit = name: unit:
    if unit.enable then
      pkgs.runCommand "unit-${mkPathSafeName name}"
        { preferLocalBuild = true;
          allowSubstitutes = false;
          inherit (unit) text;
        }
        ''
          name=${shellEscape name}
          mkdir -p "$out/$(dirname -- "$name")"
          echo -n "$text" > "$out/$name"
        ''
    else
      pkgs.runCommand "unit-${mkPathSafeName name}-disabled"
        { preferLocalBuild = true;
          allowSubstitutes = false;
        }
        ''
          name=${shellEscape name}
          mkdir -p "$out/$(dirname "$name")"
          ln -s /dev/null "$out/$name"
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
      "Systemd ${group} field `${name}' must be a valid MAC address.";

  assertNetdevMacAddress = name: group: attr:
    optional (attr ? ${name} && (! isMacAddress attr.${name} && attr.${name} != "none"))
      "Systemd ${group} field `${name}` must be a valid MAC address or the special value `none`.";


  isPort = i: i >= 0 && i <= 65535;

  assertPort = name: group: attr:
    optional (attr ? ${name} && ! isPort attr.${name})
      "Error on the systemd ${group} field `${name}': ${attr.name} is not a valid port number.";

  assertValueOneOf = name: values: group: attr:
    optional (attr ? ${name} && !elem attr.${name} values)
      "Systemd ${group} field `${name}' cannot have value `${toString attr.${name}}'.";

  assertHasField = name: group: attr:
    optional (!(attr ? ${name}))
      "Systemd ${group} field `${name}' must exist.";

  assertRange = name: min: max: group: attr:
    optional (attr ? ${name} && !(min <= attr.${name} && max >= attr.${name}))
      "Systemd ${group} field `${name}' is outside the range [${toString min},${toString max}]";

  assertMinimum = name: min: group: attr:
    optional (attr ? ${name} && attr.${name} < min)
      "Systemd ${group} field `${name}' must be greater than or equal to ${toString min}";

  assertOnlyFields = fields: group: attr:
    let badFields = filter (name: ! elem name fields) (attrNames attr); in
    optional (badFields != [ ])
      "Systemd ${group} has extra fields [${concatStringsSep " " badFields}].";

  assertInt = name: group: attr:
    optional (attr ? ${name} && !isInt attr.${name})
      "Systemd ${group} field `${name}' is not an integer";

  checkUnitConfig = group: checks: attrs: let
    # We're applied at the top-level type (attrsOf unitOption), so the actual
    # unit options might contain attributes from mkOverride and mkIf that we need to
    # convert into single values before checking them.
    defs = mapAttrs (const (v:
      if v._type or "" == "override" then v.content
      else if v._type or "" == "if" then v.content
      else v
    )) attrs;
    errors = concatMap (c: c group defs) checks;
  in if errors == [] then true
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

  generateUnits = { allowCollisions ? true, type, units, upstreamUnits, upstreamWants, packages ? cfg.packages, package ? cfg.package }:
    let
      typeDir = ({
        system = "system";
        initrd = "system";
        user = "user";
        nspawn = "nspawn";
      }).${type};
    in pkgs.runCommand "${type}-units"
      { preferLocalBuild = true;
        allowSubstitutes = false;
      } ''
      mkdir -p $out

      # Copy the upstream systemd units we're interested in.
      for i in ${toString upstreamUnits}; do
        fn=${package}/example/systemd/${typeDir}/$i
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
        fn=${package}/example/systemd/${typeDir}/$i
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
      packages="${toString packages}"

      # Filter duplicate directories
      declare -A unique_packages
      for k in $packages ; do unique_packages[$k]=1 ; done

      for i in ''${!unique_packages[@]}; do
        for fn in $i/etc/systemd/${typeDir}/* $i/lib/systemd/${typeDir}/*; do
          if ! [[ "$fn" =~ .wants$ ]]; then
            if [[ -d "$fn" ]]; then
              targetDir="$out/$(basename "$fn")"
              mkdir -p "$targetDir"
              ${lndir} "$fn" "$targetDir"
            else
              ln -s $fn $out/
            fi
          fi
        done
      done

      # Symlink units defined by systemd.units where override strategy
      # shall be automatically detected. If these are also provided by
      # systemd or systemd.packages, then add them as
      # <unit-name>.d/overrides.conf, which makes them extend the
      # upstream unit.
      for i in ${toString (mapAttrsToList
          (n: v: v.unit)
          (lib.filterAttrs (n: v: (attrByPath [ "overrideStrategy" ] "asDropinIfExists" v) == "asDropinIfExists") units))}; do
        fn=$(basename $i/*)
        if [ -e $out/$fn ]; then
          if [ "$(readlink -f $i/$fn)" = /dev/null ]; then
            ln -sfn /dev/null $out/$fn
          else
            ${if allowCollisions then ''
              mkdir -p $out/$fn.d
              ln -s $i/$fn $out/$fn.d/overrides.conf
            '' else ''
              echo "Found multiple derivations configuring $fn!"
              exit 1
            ''}
          fi
       else
          ln -fs $i/$fn $out/
        fi
      done

      # Symlink units defined by systemd.units which shall be
      # treated as drop-in file.
      for i in ${toString (mapAttrsToList
          (n: v: v.unit)
          (lib.filterAttrs (n: v: v ? overrideStrategy && v.overrideStrategy == "asDropin") units))}; do
        fn=$(basename $i/*)
        mkdir -p $out/$fn.d
        ln -s $i/$fn $out/$fn.d/overrides.conf
      done

      # Create service aliases from aliases option.
      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            ln -sfn '${name}' $out/'${name2}'
          '') (unit.aliases or [])) units)}

      # Create .wants and .requires symlinks from the wantedBy and
      # requiredBy options.
      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.wants'
            ln -sfn '../${name}' $out/'${name2}.wants'/
          '') (unit.wantedBy or [])) units)}

      ${concatStrings (mapAttrsToList (name: unit:
          concatMapStrings (name2: ''
            mkdir -p $out/'${name2}.requires'
            ln -sfn '../${name}' $out/'${name2}.requires'/
          '') (unit.requiredBy or [])) units)}

      ${optionalString (type == "system") ''
        # Stupid misc. symlinks.
        ln -s ${cfg.defaultUnit} $out/default.target
        ln -s ${cfg.ctrlAltDelUnit} $out/ctrl-alt-del.target
        ln -s rescue.target $out/kbrequest.target

        mkdir -p $out/getty.target.wants/
        ln -s ../autovt@tty1.service $out/getty.target.wants/

        ln -s ../remote-fs.target $out/multi-user.target.wants/
      ''}
    ''; # */

  makeJobScript = name: text:
    let
      scriptName = replaceStrings [ "\\" "@" ] [ "-" "_" ] (shellEscape name);
      out = (pkgs.writeShellScriptBin scriptName ''
        set -e
        ${text}
      '').overrideAttrs (_: {
        # The derivation name is different from the script file name
        # to keep the script file name short to avoid cluttering logs.
        name = "unit-script-${scriptName}";
      });
    in "${out}/bin/${scriptName}";

  unitConfig = { config, name, options, ... }: {
    config = {
      unitConfig =
        optionalAttrs (config.requires != [])
          { Requires = toString config.requires; }
        // optionalAttrs (config.wants != [])
          { Wants = toString config.wants; }
        // optionalAttrs (config.after != [])
          { After = toString config.after; }
        // optionalAttrs (config.before != [])
          { Before = toString config.before; }
        // optionalAttrs (config.bindsTo != [])
          { BindsTo = toString config.bindsTo; }
        // optionalAttrs (config.partOf != [])
          { PartOf = toString config.partOf; }
        // optionalAttrs (config.conflicts != [])
          { Conflicts = toString config.conflicts; }
        // optionalAttrs (config.requisite != [])
          { Requisite = toString config.requisite; }
        // optionalAttrs (config ? restartTriggers && config.restartTriggers != [])
          { X-Restart-Triggers = "${pkgs.writeText "X-Restart-Triggers-${name}" (toString config.restartTriggers)}"; }
        // optionalAttrs (config ? reloadTriggers && config.reloadTriggers != [])
          { X-Reload-Triggers = "${pkgs.writeText "X-Reload-Triggers-${name}" (toString config.reloadTriggers)}"; }
        // optionalAttrs (config.description != "") {
          Description = config.description; }
        // optionalAttrs (config.documentation != []) {
          Documentation = toString config.documentation; }
        // optionalAttrs (config.onFailure != []) {
          OnFailure = toString config.onFailure; }
        // optionalAttrs (config.onSuccess != []) {
          OnSuccess = toString config.onSuccess; }
        // optionalAttrs (options.startLimitIntervalSec.isDefined) {
          StartLimitIntervalSec = toString config.startLimitIntervalSec;
        } // optionalAttrs (options.startLimitBurst.isDefined) {
          StartLimitBurst = toString config.startLimitBurst;
        };
    };
  };

  serviceConfig = { config, ... }: {
    config.environment.PATH = mkIf (config.path != []) "${makeBinPath config.path}:${makeSearchPathOutput "bin" "sbin" config.path}";
  };

  stage2ServiceConfig = {
    imports = [ serviceConfig ];
    # Default path for systemd services. Should be quite minimal.
    config.path = mkAfter [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      systemd
    ];
  };

  stage1ServiceConfig = serviceConfig;

  mountConfig = { config, ... }: {
    config = {
      mountConfig =
        { What = config.what;
          Where = config.where;
        } // optionalAttrs (config.type != "") {
          Type = config.type;
        } // optionalAttrs (config.options != "") {
          Options = config.options;
        };
    };
  };

  automountConfig = { config, ... }: {
    config = {
      automountConfig =
        { Where = config.where;
        };
    };
  };

  commonUnitText = def: ''
      [Unit]
      ${attrsToSection def.unitConfig}
    '';

  targetToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text =
        ''
          [Unit]
          ${attrsToSection def.unitConfig}
        '';
    };

  serviceToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Service]
          ${let env = cfg.globalEnvironment // def.environment;
            in concatMapStrings (n:
              let s = optionalString (env.${n} != null)
                "Environment=${builtins.toJSON "${n}=${env.${n}}"}\n";
              # systemd max line length is now 1MiB
              # https://github.com/systemd/systemd/commit/e6dde451a51dc5aaa7f4d98d39b8fe735f73d2af
              in if stringLength s >= 1048576 then throw "The value of the environment variable ‘${n}’ in systemd service ‘${name}.service’ is too long." else s) (attrNames env)}
          ${if def ? reloadIfChanged && def.reloadIfChanged then ''
            X-ReloadIfChanged=true
          '' else if (def ? restartIfChanged && !def.restartIfChanged) then ''
            X-RestartIfChanged=false
          '' else ""}
          ${optionalString (def ? stopIfChanged && !def.stopIfChanged) "X-StopIfChanged=false"}
          ${attrsToSection def.serviceConfig}
        '';
    };

  socketToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Socket]
          ${attrsToSection def.socketConfig}
          ${concatStringsSep "\n" (map (s: "ListenStream=${s}") def.listenStreams)}
          ${concatStringsSep "\n" (map (s: "ListenDatagram=${s}") def.listenDatagrams)}
        '';
    };

  timerToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Timer]
          ${attrsToSection def.timerConfig}
        '';
    };

  pathToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Path]
          ${attrsToSection def.pathConfig}
        '';
    };

  mountToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Mount]
          ${attrsToSection def.mountConfig}
        '';
    };

  automountToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Automount]
          ${attrsToSection def.automountConfig}
        '';
    };

  sliceToUnit = name: def:
    { inherit (def) aliases wantedBy requiredBy enable overrideStrategy;
      text = commonUnitText def +
        ''
          [Slice]
          ${attrsToSection def.sliceConfig}
        '';
    };

  # Create a directory that contains systemd definition files from an attrset
  # that contains the file names as keys and the content as values. The values
  # in that attrset are determined by the supplied format.
  definitions = directoryName: format: definitionAttrs:
    let
      listOfDefinitions = lib.mapAttrsToList
        (name: format.generate "${name}.conf")
        definitionAttrs;
    in
    pkgs.runCommand directoryName { } ''
      mkdir -p $out
      ${(lib.concatStringsSep "\n"
        (map (pkg: "cp ${pkg} $out/${pkg.name}") listOfDefinitions)
      )}
    '';

}
