{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.autorandr;
  hookType = lib.types.lines;

  matrixOf =
    n: m: elemType:
    lib.mkOptionType rec {
      name = "matrixOf";
      description = "${toString n}×${toString m} matrix of ${elemType.description}s";
      check =
        xss:
        let
          listOfSize = l: xs: lib.isList xs && lib.length xs == l;
        in
        listOfSize n xss && lib.all (xs: listOfSize m xs && lib.all elemType.check xs) xss;
      merge = lib.mergeOneOption;
      getSubOptions =
        prefix:
        elemType.getSubOptions (
          prefix
          ++ [
            "*"
            "*"
          ]
        );
      getSubModules = elemType.getSubModules;
      substSubModules = mod: matrixOf n m (elemType.substSubModules mod);
      functor = (lib.defaultFunctor name) // {
        wrapped = elemType;
      };
    };

  profileModule = lib.types.submodule {
    options = {
      fingerprint = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          Output name to EDID mapping.
          Use `autorandr --fingerprint` to get current setup values.
        '';
        default = { };
      };

      config = lib.mkOption {
        type = lib.types.attrsOf configModule;
        description = "Per output profile configuration.";
        default = { };
      };

      hooks = lib.mkOption {
        type = hooksModule;
        description = "Profile hook scripts.";
        default = { };
      };
    };
  };

  configModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to enable the output.";
        default = true;
      };

      crtc = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.unsigned;
        description = "Output video display controller.";
        default = null;
        example = 0;
      };

      primary = lib.mkOption {
        type = lib.types.bool;
        description = "Whether output should be marked as primary";
        default = false;
      };

      position = lib.mkOption {
        type = lib.types.str;
        description = "Output position";
        default = "";
        example = "5760x0";
      };

      mode = lib.mkOption {
        type = lib.types.str;
        description = "Output resolution.";
        default = "";
        example = "3840x2160";
      };

      rate = lib.mkOption {
        type = lib.types.str;
        description = "Output framerate.";
        default = "";
        example = "60.00";
      };

      gamma = lib.mkOption {
        type = lib.types.str;
        description = "Output gamma configuration.";
        default = "";
        example = "1.0:0.909:0.833";
      };

      rotate = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "normal"
            "left"
            "right"
            "inverted"
          ]
        );
        description = "Output rotate configuration.";
        default = null;
        example = "left";
      };

      transform = lib.mkOption {
        type = lib.types.nullOr (matrixOf 3 3 lib.types.float);
        default = null;
        example = lib.literalExpression ''
          [
            [ 0.6 0.0 0.0 ]
            [ 0.0 0.6 0.0 ]
            [ 0.0 0.0 1.0 ]
          ]
        '';
        description = ''
          Refer to
          {manpage}`xrandr(1)`
          for the documentation of the transform matrix.
        '';
      };

      dpi = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        description = "Output DPI configuration.";
        default = null;
        example = 96;
      };

      scale = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              method = lib.mkOption {
                type = lib.types.enum [
                  "factor"
                  "pixel"
                ];
                description = "Output scaling method.";
                default = "factor";
                example = "pixel";
              };

              x = lib.mkOption {
                type = lib.types.either lib.types.float lib.types.ints.positive;
                description = "Horizontal scaling factor/pixels.";
              };

              y = lib.mkOption {
                type = lib.types.either lib.types.float lib.types.ints.positive;
                description = "Vertical scaling factor/pixels.";
              };
            };
          }
        );
        description = ''
          Output scale configuration.

          Either configure by pixels or a scaling factor. When using pixel method the
          {manpage}`xrandr(1)`
          option
          `--scale-from`
          will be used; when using factor method the option
          `--scale`
          will be used.

          This option is a shortcut version of the transform option and they are mutually
          exclusive.
        '';
        default = null;
        example = lib.literalExpression ''
          {
            x = 1.25;
            y = 1.25;
          }
        '';
      };
    };
  };

  hooksModule = lib.types.submodule {
    options = {
      postswitch = lib.mkOption {
        type = lib.types.attrsOf hookType;
        description = "Postswitch hook executed after mode switch.";
        default = { };
      };

      preswitch = lib.mkOption {
        type = lib.types.attrsOf hookType;
        description = "Preswitch hook executed before mode switch.";
        default = { };
      };

      predetect = lib.mkOption {
        type = lib.types.attrsOf hookType;
        description = ''
          Predetect hook executed before autorandr attempts to run xrandr.
        '';
        default = { };
      };
    };
  };

  hookToFile =
    folder: name: hook:
    lib.nameValuePair "xdg/autorandr/${folder}/${name}" {
      source = "${pkgs.writeShellScriptBin "hook" hook}/bin/hook";
    };
  profileToFiles =
    name: profile:
    with profile;
    lib.mkMerge [
      {
        "xdg/autorandr/${name}/setup".text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList fingerprintToString fingerprint
        );
        "xdg/autorandr/${name}/config".text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList configToString profile.config
        );
      }
      (lib.mapAttrs' (hookToFile "${name}/postswitch.d") hooks.postswitch)
      (lib.mapAttrs' (hookToFile "${name}/preswitch.d") hooks.preswitch)
      (lib.mapAttrs' (hookToFile "${name}/predetect.d") hooks.predetect)
    ];
  fingerprintToString = name: edid: "${name} ${edid}";
  configToString =
    name: config:
    if config.enable then
      lib.concatStringsSep "\n" (
        [ "output ${name}" ]
        ++ lib.optional (config.position != "") "pos ${config.position}"
        ++ lib.optional (config.crtc != null) "crtc ${toString config.crtc}"
        ++ lib.optional config.primary "primary"
        ++ lib.optional (config.dpi != null) "dpi ${toString config.dpi}"
        ++ lib.optional (config.gamma != "") "gamma ${config.gamma}"
        ++ lib.optional (config.mode != "") "mode ${config.mode}"
        ++ lib.optional (config.rate != "") "rate ${config.rate}"
        ++ lib.optional (config.rotate != null) "rotate ${config.rotate}"
        ++ lib.optional (config.transform != null) (
          "transform " + lib.concatMapStringsSep "," toString (lib.flatten config.transform)
        )
        ++ lib.optional (config.scale != null) (
          (if config.scale.method == "factor" then "scale" else "scale-from")
          + " ${toString config.scale.x}x${toString config.scale.y}"
        )
      )
    else
      ''
        output ${name}
        off
      '';

in
{

  options = {

    services.autorandr = {
      enable = lib.mkEnableOption "handling of hotplug and sleep events by autorandr";

      defaultTarget = lib.mkOption {
        default = "default";
        type = lib.types.str;
        description = ''
          Fallback if no monitor layout can be detected. See the docs
          (https://github.com/phillipberndt/autorandr/blob/v1.0/README.md#how-to-use)
          for further reference.
        '';
      };

      ignoreLid = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Treat outputs as connected even if their lids are closed";
      };

      matchEdid = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Match displays based on edid instead of name";
      };

      hooks = lib.mkOption {
        type = hooksModule;
        description = "Global hook scripts";
        default = { };
        example = lib.literalExpression ''
          {
            postswitch = {
              "notify-i3" = "''${pkgs.i3}/bin/i3-msg restart";
              "change-background" = readFile ./change-background.sh;
              "change-dpi" = '''
                case "$AUTORANDR_CURRENT_PROFILE" in
                  default)
                    DPI=120
                    ;;
                  home)
                    DPI=192
                    ;;
                  work)
                    DPI=144
                    ;;
                  *)
                    echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
                    exit 1
                esac
                echo "Xft.dpi: $DPI" | ''${pkgs.xorg.xrdb}/bin/xrdb -merge
              ''';
            };
          }
        '';
      };
      profiles = lib.mkOption {
        type = lib.types.attrsOf profileModule;
        description = "Autorandr profiles specification.";
        default = { };
        example = lib.literalExpression ''
          {
            "work" = {
              fingerprint = {
                eDP1 = "<EDID>";
                DP1 = "<EDID>";
              };
              config = {
                eDP1.enable = false;
                DP1 = {
                  enable = true;
                  crtc = 0;
                  primary = true;
                  position = "0x0";
                  mode = "3840x2160";
                  gamma = "1.0:0.909:0.833";
                  rate = "60.00";
                  rotate = "left";
                };
              };
              hooks.postswitch = readFile ./work-postswitch.sh;
            };
          }
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    services.udev.packages = [ pkgs.autorandr ];

    environment = {
      systemPackages = [ pkgs.autorandr ];
      etc = lib.mkMerge [
        (lib.mapAttrs' (hookToFile "postswitch.d") cfg.hooks.postswitch)
        (lib.mapAttrs' (hookToFile "preswitch.d") cfg.hooks.preswitch)
        (lib.mapAttrs' (hookToFile "predetect.d") cfg.hooks.predetect)
        (lib.mkMerge (lib.mapAttrsToList profileToFiles cfg.profiles))
      ];
    };

    systemd.services.autorandr = {
      wantedBy = [ "sleep.target" ];
      description = "Autorandr execution hook";
      after = [ "sleep.target" ];

      startLimitIntervalSec = 5;
      startLimitBurst = 1;
      serviceConfig = {
        ExecStart = ''
          ${pkgs.autorandr}/bin/autorandr \
            --batch \
            --change \
            --default ${cfg.defaultTarget} \
            ${lib.optionalString cfg.ignoreLid "--ignore-lid"} \
            ${lib.optionalString cfg.matchEdid "--match-edid"}
        '';
        Type = "oneshot";
        RemainAfterExit = false;
        KillMode = "process";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ alexnortung ];
}
