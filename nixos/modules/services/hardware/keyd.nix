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
  };

  config = mkIf cfg.enable {
    # Creates separate files in the `/etc/keyd/` directory for each key in the dictionary
    environment.etc = mapAttrs'
      (name: options:
        nameValuePair "keyd/${name}.conf" {
          text = ''
            [ids]
            ${concatStringsSep "\n" options.ids}

            ${generators.toINI {} options.settings}
            ${options.extraConfig}
          '';
        })
      cfg.keyboards;

    hardware.uinput.enable = lib.mkDefault true;

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
      environment.KEYD_SOCKET = "/run/keyd/keyd.sock";

      serviceConfig = {
        ExecStart = "${pkgs.keyd}/bin/keyd";
        Restart = "always";

        # TODO investigate why it doesn't work propeprly with DynamicUser
        # See issue: https://github.com/NixOS/nixpkgs/issues/226346
        # DynamicUser = true;
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];

        RuntimeDirectory = "keyd";

        # Hardening
        CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
        DeviceAllow = [
          "char-input rw"
          "/dev/uinput rw"
        ];
        ProtectClock = true;
        PrivateNetwork = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateUsers = false;
        PrivateMounts = true;
        PrivateTmp = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectProc = "invisible";
        SystemCallFilter = [
          "nice"
          "@system-service"
          "~@privileged"
        ];
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictSUIDSGID = true;
        IPAddressDeny = [ "any" ];
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProcSubset = "pid";
        UMask = "0077";
      };
    };
  };
}
