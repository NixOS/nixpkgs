{ lib, pkgs, config, ... }:

let
  cfg = config.programs.yabar;

  mapExtra = v: lib.concatStringsSep "\n" (lib.mapAttrsToList (
    key: val: "${key} = ${if (builtins.isString val) then "\"${val}\"" else "${builtins.toString val}"};"
  ) v);

  listKeys = r: builtins.concatStringsSep "," (builtins.map (n: "\"${n}\"") (builtins.attrNames r));

  configFile = let
    bars = lib.mapAttrsToList (
      name: cfg: ''
        ${name}: {
          font: "${cfg.font}";
          position: "${cfg.position}";

          ${mapExtra cfg.extra}

          block-list: [${listKeys cfg.indicators}]

          ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (
            name: cfg: ''
              ${name}: {
                exec: "${cfg.exec}";
                align: "${cfg.align}";
                ${mapExtra cfg.extra}
              };
            ''
          ) cfg.indicators)}
        };
      ''
    ) cfg.bars;
  in pkgs.writeText "yabar.conf" ''
    bar-list = [${listKeys cfg.bars}];
    ${builtins.concatStringsSep "\n" bars}
  '';
in
  {
    options.programs.yabar = {
      enable = lib.mkEnableOption "yabar, a status bar for X window managers";

      package = lib.mkOption {
        default = pkgs.yabar-unstable;
        defaultText = lib.literalExpression "pkgs.yabar-unstable";
        example = lib.literalExpression "pkgs.yabar";
        type = lib.types.package;

        # `yabar-stable` segfaults under certain conditions.
        # remember to update yabar.passthru.tests if nixos switches back to it!
        apply = x: if x == pkgs.yabar-unstable then x else lib.flip lib.warn x ''
          It's not recommended to use `yabar' with `programs.yabar', the (old) stable release
          tends to segfault under certain circumstances:

          * https://github.com/geommer/yabar/issues/86
          * https://github.com/geommer/yabar/issues/68
          * https://github.com/geommer/yabar/issues/143

          Most of them don't occur on master anymore, until a new release is published, it's recommended
          to use `yabar-unstable'.
        '';

        description = ''
          The package which contains the `yabar` binary.

          Nixpkgs provides the `yabar` and `yabar-unstable`
          derivations since 18.03, so it's possible to choose.
        '';
      };

      bars = lib.mkOption {
        default = {};
        type = lib.types.attrsOf(lib.types.submodule {
          options = {
            font = lib.mkOption {
              default = "sans bold 9";
              example = "Droid Sans, FontAwesome Bold 9";
              type = lib.types.str;

              description = ''
                The font that will be used to draw the status bar.
              '';
            };

            position = lib.mkOption {
              default = "top";
              example = "bottom";
              type = lib.types.enum [ "top" "bottom" ];

              description = ''
                The position where the bar will be rendered.
              '';
            };

            extra = lib.mkOption {
              default = {};
              type = lib.types.attrsOf lib.types.str;

              description = ''
                An attribute set which contains further attributes of a bar.
              '';
            };

            indicators = lib.mkOption {
              default = {};
              type = lib.types.attrsOf(lib.types.submodule {
                options.exec = lib.mkOption {
                  example = "YABAR_DATE";
                  type = lib.types.str;
                  description = ''
                     The type of the indicator to be executed.
                  '';
                };

                options.align = lib.mkOption {
                  default = "left";
                  example = "right";
                  type = lib.types.enum [ "left" "center" "right" ];

                  description = ''
                    Whether to align the indicator at the left or right of the bar.
                  '';
                };

                options.extra = lib.mkOption {
                  default = {};
                  type = lib.types.attrsOf (lib.types.either lib.types.str lib.types.int);

                  description = ''
                    An attribute set which contains further attributes of a indicator.
                  '';
                };
              });

              description = ''
                Indicators that should be rendered by yabar.
              '';
            };
          };
        });

        description = ''
          List of bars that should be rendered by yabar.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.user.services.yabar = {
        description = "yabar service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        script = ''
          ${cfg.package}/bin/yabar -c ${configFile}
        '';

        serviceConfig.Restart = "always";
      };
    };
  }
