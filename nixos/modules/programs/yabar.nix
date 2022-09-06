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
      enable = mkEnableOption (lib.mdDoc "yabar");

      package = mkOption {
        default = pkgs.yabar-unstable;
        defaultText = literalExpression "pkgs.yabar-unstable";
        example = literalExpression "pkgs.yabar";
        type = types.package;

        # `yabar-stable` segfaults under certain conditions.
        apply = x: if x == pkgs.yabar-unstable then x else flip warn x ''
          It's not recommended to use `yabar' with `programs.yabar', the (old) stable release
          tends to segfault under certain circumstances:

          * https://github.com/geommer/yabar/issues/86
          * https://github.com/geommer/yabar/issues/68
          * https://github.com/geommer/yabar/issues/143

          Most of them don't occur on master anymore, until a new release is published, it's recommended
          to use `yabar-unstable'.
        '';

        description = lib.mdDoc ''
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
              type = types.str;

              description = lib.mdDoc ''
                The font that will be used to draw the status bar.
              '';
            };

            position = mkOption {
              default = "top";
              example = "bottom";
              type = types.enum [ "top" "bottom" ];

              description = lib.mdDoc ''
                The position where the bar will be rendered.
              '';
            };

            extra = mkOption {
              default = {};
              type = types.attrsOf types.str;

              description = lib.mdDoc ''
                An attribute set which contains further attributes of a bar.
              '';
            };

            indicators = mkOption {
              default = {};
              type = types.attrsOf(types.submodule {
                options.exec = mkOption {
                  example = "YABAR_DATE";
                  type = types.str;
                  description = lib.mdDoc ''
                     The type of the indicator to be executed.
                  '';
                };

                options.align = mkOption {
                  default = "left";
                  example = "right";
                  type = types.enum [ "left" "center" "right" ];

                  description = lib.mdDoc ''
                    Whether to align the indicator at the left or right of the bar.
                  '';
                };

                options.extra = mkOption {
                  default = {};
                  type = types.attrsOf (types.either types.str types.int);

                  description = lib.mdDoc ''
                    An attribute set which contains further attributes of a indicator.
                  '';
                };
              });

              description = lib.mdDoc ''
                Indicators that should be rendered by yabar.
              '';
            };
          };
        });

        description = lib.mdDoc ''
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
