{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.yabar;

  mapExtra = v: lib.concatStringsSep "\n" (mapAttrsToList (
    key: val: "${key} = ${if (isString val) then "\"${val}\"" else "${builtins.toString val}"};"
  ) v);

  listKeys = r: concatStringsSep "," (map (n: "\"${n}\"") (attrNames r));

  configFile = let
    bars = mapAttrsToList (
      name: cfg: ''
        ${name}: {
          font: "${cfg.font}";
          position: "${cfg.position}";

          ${mapExtra cfg.extra}

          block-list: [${listKeys cfg.indicators}]

          ${concatStringsSep "\n" (mapAttrsToList (
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
    ${concatStringsSep "\n" bars}
  '';
in
  {
    options.programs.yabar = {
      enable = mkEnableOption "yabar";

      package = mkOption {
        default = pkgs.yabar;
        example = literalExample "pkgs.yabar-unstable";
        type = types.package;

        description = ''
          The package which contains the `yabar` binary.

          Nixpkgs provides the `yabar` and `yabar-unstable`
          derivations since 18.03, so it's possible to choose.
        '';
      };

      bars = mkOption {
        default = {};
        type = types.attrsOf(types.submodule {
          options = {
            font = mkOption {
              default = "sans bold 9";
              example = "Droid Sans, FontAwesome Bold 9";
              type = types.string;

              description = ''
                The font that will be used to draw the status bar.
              '';
            };

            position = mkOption {
              default = "top";
              example = "bottom";
              type = types.enum [ "top" "bottom" ];

              description = ''
                The position where the bar will be rendered.
              '';
            };

            extra = mkOption {
              default = {};
              type = types.attrsOf types.string;

              description = ''
                An attribute set which contains further attributes of a bar.
              '';
            };

            indicators = mkOption {
              default = {};
              type = types.attrsOf(types.submodule {
                options.exec = mkOption {
                  example = "YABAR_DATE";
                  type = types.string;
                  description = ''
                     The type of the indicator to be executed.
                  '';
                };

                options.align = mkOption {
                  default = "left";
                  example = "right";
                  type = types.enum [ "left" "center" "right" ];

                  description = ''
                    Whether to align the indicator at the left or right of the bar.
                  '';
                };

                options.extra = mkOption {
                  default = {};
                  type = types.attrsOf (types.either types.string types.int);

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

    config = mkIf cfg.enable {
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
