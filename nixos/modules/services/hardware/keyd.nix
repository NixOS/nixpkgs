{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keyd;

  keyboardOptions = { ... }: {
    options = {
      ids = mkOption {
        type = types.listOf types.str;
        default = [ "*" ];
        example = [ "*" "-0123:0456" ];
        description = lib.mdDoc ''
          Device identifiers, as shown by {manpage}`keyd(1)`.
        '';
      };

      settings = mkOption {
        type = (pkgs.formats.ini { }).type;
        default = { };
        example = {
          main = {
            capslock = "overload(control, esc)";
            rightalt = "layer(rightalt)";
          };

          rightalt = {
            j = "down";
            k = "up";
            h = "left";
            l = "right";
          };
        };
        description = lib.mdDoc ''
          Configuration, except `ids` section, that is written to {file}`/etc/keyd/<keyboard>.conf`.
          Appropriate names can be used to write non-alpha keys, for example "equal" instead of "=" sign (see <https://github.com/NixOS/nixpkgs/issues/236622>).
          See <https://github.com/rvaiya/keyd> how to configure.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          [control+shift]
          h = left
        '';
        description = lib.mdDoc ''
          Extra configuration that is appended to the end of the file.
          **Do not** write `ids` section here, use a separate option for it.
          You can use this option to define compound layers that must always be defined after the layer they are comprised.
        '';
      };
    };
  };
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "keyd" "ids" ]
      ''Use keyboards.<filename>.ids instead. If you don't need a multi-file configuration, just add keyboards.default before the ids. See https://github.com/NixOS/nixpkgs/pull/243271.'')
    (mkRemovedOptionModule [ "services" "keyd" "settings" ]
      ''Use keyboards.<filename>.settings instead. If you don't need a multi-file configuration, just add keyboards.default before the settings. See https://github.com/NixOS/nixpkgs/pull/243271.'')
  ];

  options.services.keyd = {
    enable = mkEnableOption (lib.mdDoc "keyd, a key remapping daemon");

    package = mkPackageOption pkgs "keyd" { example = "keyd"; };

    keyboards = mkOption {
      type = types.attrsOf (types.submodule keyboardOptions);
      default = { };
      example = literalExpression ''
        {
          default = {
            ids = [ "*" ];
            settings = {
              main = {
                capslock = "overload(control, esc)";
              };
            };
          };
          externalKeyboard = {
            ids = [ "1ea7:0907" ];
            settings = {
              main = {
                esc = capslock;
              };
            };
          };
        }
      '';
      description = mdDoc ''
        Configuration for one or more device IDs. Corresponding files in the /etc/keyd/ directory are created according to the name of the keys (like `default` or `externalKeyboard`).
      '';
    };

    application-mapping = {
      enable = mkEnableOption (lib.mdDoc "keyd-application-mapper script, which allows for different sets of keybindings based on the application window that is currently in focus");
      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of users which are allowed to run the application mapping script.
        '';
      };
      settings = mkOption {
        inherit ((pkgs.formats.ini {})) type;
        default = {};
        example = literalExpression ''
          {
            kitty = {
              "ctrl.j" = "down";
              capslock = "esc";
            };
            "firefox|youtube.com" = {
              "alt.]" = "C-S-t";
            };
            "steam-app-1282100|remnant2" = {
              f13 = "x";
            };
          }
        '';
        description = mdDoc ''
          Per-application hotkey configuration. You can match by window class, title, or both. See <https://github.com/rvaiya/keyd/blob/master/docs/keyd-application-mapper.scdoc> for more information.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Creates separate files in the `/etc/keyd/` directory for each key in the dictionary
    environment.etc = (mapAttrs'
      (name: options:
        nameValuePair "keyd/${name}.conf" {
          text = ''
            [ids]
            ${concatStringsSep "\n" options.ids}

            ${generators.toINI {} options.settings}
            ${options.extraConfig}
          '';
        })
      cfg.keyboards)
      // {
        "keyd/application-mapper/app.conf" = lib.mkIf (cfg.application-mapping.settings != {}) {
          text = ''
            ${generators.toINI {} cfg.application-mapping.settings}
          '';
        };
      };

    hardware.uinput.enable = lib.mkDefault true;
    users.groups."keyd".name = "keyd";
    environment.systemPackages = [ cfg.package ];
    users.users = lib.genAttrs cfg.application-mapping.users (user: {
      extraGroups = [ "keyd" ];
    });

    systemd.services.keyd = {
      description = "Keyd remapping daemon";
      documentation = [ "man:keyd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = mapAttrsToList
        (name: options:
          config.environment.etc."keyd/${name}.conf".source
        )
        cfg.keyboards;

      # this is configurable in 2.4.2, later versions seem to remove this option.
      # post-2.4.2 may need to set makeFlags in the derivation:
      #
      #     makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];
      environment.KEYD_SOCKET = "/run/keyd/keyd.socket";

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/keyd";
        Restart = "always";

        # TODO investigate why it doesn't work propeprly with DynamicUser
        # See issue: https://github.com/NixOS/nixpkgs/issues/226346
        # DynamicUser = true;
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];
      };
    };

    systemd.user.services.keyd-application-mapper = {
      description = "partner script to keyd";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Environment = "PATH=${cfg.package}/bin/:$PATH";
        ExecStart = "${cfg.package}/bin/keyd-application-mapper -v";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      wantedBy = ["graphical-session.target"];
    };

    systemd.services.keyd-config-permissions = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.coreutils}/bin/mkdir -p /etc/keyd
        ${pkgs.coreutils}/bin/chmod -R 775 /etc/keyd
        ${pkgs.coreutils}/bin/chown -R root:keyd /etc/keyd
      '';
    };
  };
}
