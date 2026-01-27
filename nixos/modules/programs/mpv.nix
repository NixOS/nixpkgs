{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    generators
    literalExpression
    mkIf
    mkOption
    types
    ;
  inherit (builtins) typeOf stringLength;

  cfg = config.programs.mpv;

  mpvOption =
    with types;
    oneOf [
      str
      int
      bool
      float
    ];
  mpvOptionDup = types.either mpvOption (types.listOf mpvOption);
  mpvOptions = types.attrsOf mpvOptionDup;
  mpvProfiles = types.attrsOf mpvOptions;
  mpvBindings = types.attrsOf types.str;
  mpvDefaultProfiles = types.listOf types.str;

  renderOption =
    option:
    rec {
      int = toString option;
      float = int;
      bool = lib.boolToYesNo option;
      string = option;
    }
    .${typeOf option};

  renderOptionValue =
    value:
    let
      rendered = renderOption value;
      length = toString (stringLength rendered);
    in
    "%${length}%${rendered}";

  renderOptions = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault { mkValueString = renderOptionValue; } "=";
    listsAsDuplicateKeys = true;
  };

  renderScriptOptions = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault { mkValueString = renderOption; } "=";
    listsAsDuplicateKeys = true;
  };

  renderProfiles = generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault { mkValueString = renderOptionValue; } "=";
    listsAsDuplicateKeys = true;
  };

  renderBindings =
    bindings: lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name} ${value}") bindings);

  renderDefaultProfiles = profiles: renderOptions { profile = lib.concatStringsSep "," profiles; };

in
{
  options = {
    programs.mpv = {
      enable = lib.mkEnableOption "mpv";

      package = lib.mkPackageOption pkgs "mpv" {
        example = ''
          pkgs.mpv.override (prev: {
            mpv-unwrapped = prev.mpv-unwrapped.override {
              vapoursynthSupport = true;
            };
            youtubeSupport = true;
          })
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
        visible = false;
        description = ''
          Resulting mpv package.
        '';
      };

      scripts = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.mpvScripts.mpris ]";
        description = ''
          List of scripts to use with mpv.
        '';
      };

      scriptOpts = mkOption {
        description = ''
          Script options added to
          {file}`/etc/mpv/script-opts/`. See
          {manpage}`mpv(1)`
          for the full list of options of builtin scripts.
        '';
        type = types.attrsOf mpvOptions;
        default = { };
        example = {
          osc = {
            scalewindowed = 2.0;
            vidscale = false;
            visibility = "always";
          };
        };
      };

      config = mkOption {
        description = ''
          Configuration written to
          {file}`/etc/mpv/mpv.conf`. See
          {manpage}`mpv(1)`
          for the full list of options.
        '';
        type = mpvOptions;
        default = { };
        example = literalExpression ''
          {
            profile = "gpu-hq";
            force-window = true;
            ytdl-format = "bestvideo+bestaudio";
            cache-default = 4000000;
          }
        '';
      };

      includes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''
          [
            "/path/to/config.inc";
            "/path/to/conditional.inc";
          ]
        '';
        description = "List of configuration files to include at the end of mpv.conf.";
      };

      profiles = mkOption {
        description = ''
          Sub-configuration options for specific profiles written to
          {file}`/etc/mpv/mpv.conf`. See
          {option}`programs.mpv.config` for more information.
        '';
        type = mpvProfiles;
        default = { };
        example = literalExpression ''
          {
            fast = {
              vo = "vdpau";
            };
            "protocol.dvd" = {
              profile-desc = "profile for dvd:// streams";
              alang = "en";
            };
          }
        '';
      };

      defaultProfiles = mkOption {
        description = ''
          Profiles to be applied by default. Options set by them are overridden
          by options set in [](#opt-programs.mpv.config).
        '';
        type = mpvDefaultProfiles;
        default = [ ];
        example = [ "gpu-hq" ];
      };

      bindings = mkOption {
        description = ''
          Input configuration written to
          {file}`/etc/mpv/input.conf`. See
          {manpage}`mpv(1)`
          for the full list of options.
        '';
        type = mpvBindings;
        default = { };
        example = literalExpression ''
          {
            WHEEL_UP = "seek 10";
            WHEEL_DOWN = "seek -10";
            "Alt+0" = "set window-scale 0.5";
          }
        '';
      };

      extraInput = mkOption {
        description = ''
          Additional lines that are appended to {file}`/etc/mpv/input.conf`.
           See {manpage}`mpv(1)` for the full list of options.
        '';
        type = types.lines;
        default = "";
        example = ''
          esc         quit                        #! Quit
          #           script-binding uosc/video   #! Video tracks
          # additional comments
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.finalPackage ];
        programs.mpv.finalPackage =
          if cfg.scripts == [ ] then
            cfg.package
          else
            cfg.package.override (prev: {
              scripts = (prev.scripts or [ ]) ++ cfg.scripts;
            });
      }

      (mkIf (cfg.includes != [ ]) {
        environment.etc."mpv/mpv.conf" = {
          text = lib.mkAfter (lib.concatMapStringsSep "\n" (x: "include=${x}") cfg.includes);
        };
      })

      (mkIf (cfg.config != { } || cfg.profiles != { }) {
        environment.etc."mpv/mpv.conf".text = ''
          ${lib.optionalString (cfg.defaultProfiles != [ ]) (renderDefaultProfiles cfg.defaultProfiles)}
          ${lib.optionalString (cfg.config != { }) (renderOptions cfg.config)}
          ${lib.optionalString (cfg.profiles != { }) (renderProfiles cfg.profiles)}
        '';
      })
      (mkIf (cfg.bindings != { } || cfg.extraInput != "") {
        environment.etc."mpv/input.conf".text = lib.mkMerge [
          (mkIf (cfg.bindings != { }) (renderBindings cfg.bindings))
          (mkIf (cfg.extraInput != "") cfg.extraInput)
        ];
      })
      {
        environment.etc = lib.mapAttrs' (
          name: value:
          lib.nameValuePair "mpv/script-opts/${name}.conf" {
            text = renderScriptOptions value;
          }
        ) cfg.scriptOpts;
      }
    ]
  );
  meta.maintainers = with lib.maintainers; [
    Stebalien
  ];
}
