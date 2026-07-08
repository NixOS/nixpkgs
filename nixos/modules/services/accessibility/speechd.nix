{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd;

  # TODO: Remove this in 27.05
  legacyStringModules = lib.filterAttrs (name: value: lib.isString value) cfg.modules;

  inherit (lib)
    mapAttrs'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    ;

  mkExtraConfigOption =
    { }:
    mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra lines appended verbatim to this module's Speech Dispatcher
        configuration file.

        See the [Speech Dispatcher manual](https://github.com/brailcom/speechd/blob/master/doc/speech-dispatcher.texi)
        for the general directive syntax, and the default
        shipped in `${"$"}{cfg.package}/etc/speech-dispatcher/modules/`
        for the directives this specific module accepts.
      '';
      example = "";
    };

  mkSimpleGenerateEtc =
    name: confFile: modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/${name}.conf".text =
        builtins.replaceStrings
          [ "Debug 0" "Debug 1" ]
          [
            "Debug ${if modCfg.debug then "1" else "0"}"
            "Debug ${if modCfg.debug then "1" else "0"}"
          ]
          (builtins.readFile "${cfg.package}/etc/speech-dispatcher/modules/${confFile}")
        + "\n"
        + modCfg.extraConfig;
    };

  mkDebugAssertion =
    name: modCfg:
    lib.optional (modCfg ? extraConfig && lib.hasInfix "Debug" modCfg.extraConfig) {
      assertion = false;
      message = ''
        `services.speechd.modules.${name}.extraConfig` contains a Debug directive.
        Use `services.speechd.modules.${name}.debug` instead.
      '';
    };

  mkSimpleAddModule = binary: name: ''AddModule "${name}" "${binary}" "${name}.conf"'' + "\n";

  outputModules =
    let
      mods =
        lib.mapAttrs
          (
            name: filename:
            import ./speechd-modules/${filename}.nix {
              inherit lib pkgs;
              inherit (lib)
                mkPackageOption
                mkEnableOption
                mkOption
                ;
              inherit mkExtraConfigOption;
            }
          )
          {
            # keep-sorted start case=no
            espeakNg = "espeak-ng";
            flite = "flite";
            pico = "pico";
            #keep-sorted end
          };
      binaryFor =
        mod: modCfg:
        let
          b = mod.binary or "sd_generic";
        in
        if lib.isFunction b then b modCfg else b;
    in
    lib.mapAttrs (
      name: mod:
      mod
      // {
        generateEtc = mod.generateEtc or (mkSimpleGenerateEtc name mod.confFile);
        generateAddModule =
          mod.generateAddModule or (modCfg: mkSimpleAddModule (binaryFor mod modCfg) name);
        assertions = modCfg: (mkDebugAssertion name modCfg) ++ (mod.assertions or (_: [ ])) modCfg;
      }
    ) mods;

in
{
  imports = [
    # TODO: Remove in 27.05
    (lib.mkRenamedOptionModule [ "services" "speechd" "config" ] [ "services" "speechd" "extraConfig" ])
    # TODO: Remove in 27.05
    (lib.mkRenamedOptionModule
      [ "services" "speechd" "clients" ]
      [ "services" "speechd" "extraClients" ]
    )
  ];

  options.services.speechd = {
    # FIXME: figure out how to deprecate this EXTREMELY CAREFULLY
    # default guessed conservatively in ../misc/graphical-desktop.nix
    enable = mkEnableOption "speech-dispatcher speech synthesizer daemon";

    package = mkPackageOption pkgs "speechd" { };

    logLevel = mkOption {
      type = lib.types.ints.between 0 5;
      default = 3;
      description = ''
        Specifies the verbosity of information written to the logfile  or screen.
        0 means nothing, 5 means everything (not recommended).

        Sets {var}`LogLevel`.
      '';
      example = "5";
    };

    logDir = mkOption {
      type = lib.types.either (lib.types.enum [
        "default"
        "stdout"
      ]) lib.types.str;
      default = "default";
      description = ''
        Directory where Speech Dispatcher logs are written.
        Use {var}`"default"` for the standard system log destination,
        {var}`"stdout"` for console output, or an absolute path to a
        custom directory.

        Sets {var}`LogDir`.
      '';
      example = "/var/log/speech-dispatcher/";
    };

    defaultVolume = mkOption {
      type = lib.types.ints.between (-100) 100;
      default = 100;
      description = ''
        Default volume of synthesized speech, ranging from -100 (quietest)
        to 100 (the synthesizer's default volume).

        Sets {var}`DefaultVolume`.
      '';
      example = "10";
    };

    symbolsPreproc = mkOption {
      type = lib.types.enum [
        "no"
        "none"
        "all"
        "char"
      ];
      default = "char";
      description = ''
        Controls the level of punctuation symbol pre-processing performed
        by the server rather than the output module.
        {var}`"no"` disables pre-processing entirely.
        {var}`"none"` enables only rules that are always active.
        {var}`"all"` enables all server punctuation rules.
        {var}`"char"` enables all server rules including spacing rules.

        Sets {var}`SymbolsPreproc`.
      '';
    };

    symbolsPreprocFiles = mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "gender-neutral.dic"
        "font-variants.dic"
        "symbols.dic"
        "emojis.dic"
        "orca.dic"
        "orca-chars.dic"
      ];
      description = ''
        Preprocessing dictionary files loaded by the server for symbol
        substitution, in order from most to least specific localization.

        Sets {var}`SymbolsPreprocFile`.
      '';
    };

    audioOutputMethod = mkOption {
      type = lib.types.nonEmptyListOf (
        lib.types.enum [
          "pulse"
          "alsa"
          "oss"
          # "nas"

          # FIXME uncomment when pipewire is a derivation input
          # https://github.com/NixOS/nixpkgs/pull/470797
          # "pipewire"
          "libao"
        ]
      );
      default = [
        "libao"
        "pulse"
        "alsa"
        # FIXME uncomment when pipewire is a derivation input
        # https://github.com/NixOS/nixpkgs/pull/470797
        # "pipewire"
        "oss"
      ];
      description = ''
        Ordered list of audio output backends to try at runtime, falling
        back to the next one if opening a device fails.

        Sets {var}`AudioOutputMethod` (as a comma-separated list).
        Overrides {var}`speechd` to include the speciffic backend.
      '';
    };

    defaultModule = mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Name of the default output module. Must match a name from an
        {var}`AddModule` directive.

        Sets {var}`DefaultModule`.
      '';
      example = "espeak-ng";
    };

    extraConfig = mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        System wide configuration file for Speech Dispatcher. This will be used if no user configuration file is found.
      '';
      example = ''
        AddModule "module_name" "module_binary" "module_config"
      '';
    };

    modules = mkOption {
      description = ''
        Predefined interfaces for Speech Dispatcher output modules.
      '';
      type = lib.types.submodule {
        # TODO remove in 27.05
        freeformType = lib.types.attrsOf (lib.types.either lib.types.lines lib.types.anything);
        options = lib.mapAttrs (
          name: mod:
          mkOption {
            type = mod.type;
            default = { };
            visible = mod.visible or true;
            description = "Configuration for the ${mod.displayName} Speech Dispatcher output module.";
          }
        ) outputModules;
      };
    };

    extraModules = mkOption {
      type = with lib.types; submodule { freeformType = attrsOf lines; };
      default = { };
      description = ''
        Extra configuration files of output modules.
      '';
      example = {
        # TODO find a better example
        llia-generic = ''
          AddVoice        "cs"  "male1"   "kadlec"
          AddVoice        "sk"  "male1"   "bob"
        '';
      };
    };

    extraClients = mkOption {
      type = with lib.types; submodule { freeformType = attrsOf lines; };
      default = { };
      description = ''
        Client specific configuration.
      '';
      example = {
        emacs = ''
          BeginClient "emacs:*"
          # Example:
          #   DefaultPunctuationMode "some"
          EndClient
        '';
      };
    };

    finalPackage = mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = ''
        The Speech Dispatcher package used by the module.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.speechd.finalPackage = (
      cfg.package.override {
        withEspeak = cfg.modules.espeakNg.enable;
        espeak = cfg.modules.espeakNg.finalPackage;
        withPico = cfg.modules.pico.enable;
        picotts = cfg.modules.pico.package;
        withFlite = cfg.modules.flite.enable;
        flite = cfg.modules.flite.package;
        # Use the defined audio output backend
        withPulse = lib.elem "pulse" cfg.audioOutputMethod;
        withLibao = lib.elem "libao" cfg.audioOutputMethod;
        withAlsa = lib.elem "alsa" cfg.audioOutputMethod;
        withOss = lib.elem "oss" cfg.audioOutputMethod;

        # FIXME uncomment when pipewire is a derivation input
        # https://github.com/NixOS/nixpkgs/pull/470797
        # withPipewire = lib.elem "pipewire" cfg.audioOutputMethod;
      }
    );

    # TODO: Remove this in 27.05
    services.speechd.extraModules = legacyStringModules;

    assertions =
      # The user cannot add a module in `extraModules` that is already defined in `modules`
      lib.concatLists (
        lib.mapAttrsToList (name: mod: [
          {
            assertion = !(cfg.extraModules ? "${lib.removeSuffix ".conf" mod.confFile}");
            message = ''
              ${name} is a predefined module in `services.speechd.modules.${name}`.
              Use the predefined module instead of defining your own.
            '';
          }
        ]) outputModules
      )
      # The user cannot define a module in AddModule that is already defined in `modules`
      ++ lib.concatLists (
        lib.mapAttrsToList (name: mod: [
          {
            assertion =
              !(lib.any (line: builtins.match ''[[:space:]]*AddModule[[:space:]]+"${name}".*'' line != null) (
                lib.splitString "\n" cfg.extraConfig
              ));
            message = ''
              services.speechd.extraConfig contains an AddModule directive for "${name}",
              which collides with the predefined module services.speechd.modules.${name}.
              Remove the duplicate AddModule line or rename the module.
            '';
          }
        ]) outputModules
      )
      # The user cannot set a variable in any `extraConfig` that has a named variable
      ++ lib.concatLists (
        lib.mapAttrsToList (
          name: mod:
          lib.optionals (mod ? assertions) (
            map (a: a // { message = "[services.speechd.modules.${name}] " + a.message; }) (
              mod.assertions cfg.modules.${name}
            )
          )
        ) outputModules
      )
      # The user cannot set a module in defaultModule that is not defined in `modules` or `extraModules`
      ++ [
        {
          assertion =
            cfg.defaultModule == null
            || (outputModules ? ${cfg.defaultModule} && cfg.modules.${cfg.defaultModule}.enable)
            || cfg.extraModules ? "${cfg.defaultModule}";
          message = ''
            services.speechd.defaultModule is set to "${toString cfg.defaultModule}" but it
            does not match the attribute name of an enabled module under
            services.speechd.modules, nor a key in services.speechd.extraModules.
          '';
        }
      ]
      ++ [
        # TODO: Remove this assertion in 27.05
        {
          assertion = lib.all (
            name: builtins.elem name (lib.attrNames outputModules) || lib.isString cfg.modules.${name}
          ) (lib.attrNames cfg.modules);
          message = ''
            services.speechd.modules contains unrecognized backend name(s): ${
              toString (
                lib.filter (
                  name: !(builtins.elem name (lib.attrNames outputModules) || lib.isString cfg.modules.${name})
                ) (lib.attrNames cfg.modules)
              )
            }.
            Valid backend names are: ${toString (lib.attrNames outputModules)}.
          '';
        }
      ]
      ++ [
        # TODO: Remove this assertion in 27.05
        {
          assertion = lib.all (name: !(cfg.extraModules ? ${name})) (lib.attrNames legacyStringModules);
          message = ''
            The following `services.speechd.modules` entries are raw configuration
            strings that collide with a same-named `services.speechd.extraModules`
            entry: ${
              toString (lib.filter (name: cfg.extraModules ? ${name}) (lib.attrNames legacyStringModules))
            }.
            Move everything to `services.speechd.extraModules.<name>`.
          '';
        }
      ]
      ++
        lib.mapAttrsToList
          (directive: option: {
            assertion = !(lib.hasInfix directive cfg.extraConfig);
            message = ''
              services.speechd.extraConfig contains a ${directive} directive.
              Use services.speechd.${option} instead.
            '';
          })
          {
            LogLevel = "logLevel";
            LogDir = "logDir";
            DefaultVolume = "defaultVolume";
            SymbolsPreproc = "symbolsPreproc";
            AudioOutputMethod = "audioOutputMethod";
            DefaultModule = "defaultModule";
          };

    # TODO: Remove in 27.05 along with freeformType on `modules`.
    warnings = lib.mapAttrsToList (name: _: ''
      The option `services.speechd.modules.${name}` is set as a raw configuration string.
      Raw configurations have moved to `services.speechd.extraModules.${name}` instead.
    '') legacyStringModules;

    environment = {
      systemPackages = [
        cfg.finalPackage
      ];

      etc = {
        "speech-dispatcher/speechd.conf".text =
          cfg.extraConfig
          + "\n"
          + ''
            LogLevel ${toString cfg.logLevel}
            LogDir "${cfg.logDir}"
            DefaultVolume ${toString cfg.defaultVolume}
            SymbolsPreproc "${cfg.symbolsPreproc}"
          ''
          + lib.concatMapStrings (file: ''
            SymbolsPreprocFile "${file}"
          '') cfg.symbolsPreprocFiles
          + ''
            AudioOutputMethod "${lib.concatStringsSep "," cfg.audioOutputMethod}"
          ''
          + lib.concatStrings (
            lib.mapAttrsToList (
              name: mod: lib.optionalString cfg.modules.${name}.enable (mod.generateAddModule cfg.modules.${name})
            ) outputModules
          )
          + lib.optionalString (cfg.defaultModule != null) ''
            DefaultModule ${toString cfg.defaultModule}
          ''
          + ''
            Include "clients/*.conf"
          '';
      }
      // (mapAttrs' (name: value: {
        name = "speech-dispatcher/modules/${name}.conf";
        value.text = value;
      }) cfg.extraModules)
      // (mapAttrs' (name: value: {
        name = "speech-dispatcher/clients/${name}.conf";
        value.text = value;
      }) cfg.extraClients)
      // lib.mergeAttrsList (
        lib.mapAttrsToList (name: mod: mod.generateEtc cfg.modules.${name}) outputModules
      );
    };

    # Ensure that the log directory is created
    systemd.tmpfiles.rules = lib.optional (
      cfg.logDir != "default" && cfg.logDir != "stdout"
    ) "d ${cfg.logDir} 1777 - - - -";

    systemd.packages = [ cfg.finalPackage ];
    # have to set `wantedBy` since `systemd.packages` ignores `[Install]`
    systemd.user.sockets.speech-dispatcher.wantedBy = [ "sockets.target" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
