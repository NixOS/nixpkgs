{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.attrsets) mapAttrs' mapAttrsToList nameValuePair;
  inherit (lib.generators) toINI;
  inherit (lib.modules) mkDefault mkIf mkRemovedOptionModule;
  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.strings) concatStringsSep;

  cfg = config.services.keyd;

  keyboardOptions = {
    options = {
      ids = mkOption {
        type = with types; listOf str;
        default = [ "*" ];
        example = [
          "*"
          "-0123:0456"
        ];
        description = ''
          Device identifiers, as shown by {manpage}`keyd(1)`.
        '';
      };

      settings = mkOption {
        inherit (pkgs.formats.ini { }) type;
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
        description = ''
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
        description = ''
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
    (lib.mkRemovedOptionModule [ "services" "keyd" "ids" ]
      "Use keyboards.<filename>.ids instead. If you don't need a multi-file configuration, just add keyboards.default before the ids. See https://github.com/NixOS/nixpkgs/pull/243271."
    )
    (lib.mkRemovedOptionModule [ "services" "keyd" "settings" ]
      "Use keyboards.<filename>.settings instead. If you don't need a multi-file configuration, just add keyboards.default before the settings. See https://github.com/NixOS/nixpkgs/pull/243271."
    )
  ];

  options.services.keyd = {
    enable = mkEnableOption "keyd, a key remapping daemon";

    package = lib.mkPackageOption pkgs "keyd" { };

    keyboards = mkOption {
      type = with types; attrsOf (submodule keyboardOptions);
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
      description = ''
        Configuration for one or more device IDs. Corresponding files in the /etc/keyd/ directory are created according to the name of the keys (like `default` or `externalKeyboard`).
      '';
    };
  };

  config = mkIf cfg.enable {
    # Creates separate files in the `/etc/keyd/` directory for each key in the dictionary
    environment.etc = mapAttrs' (
      name: options:
      nameValuePair "keyd/${name}.conf" {
        text = ''
          [ids]
          ${concatStringsSep "\n" options.ids}

          ${toINI { } options.settings}
          ${options.extraConfig}
        '';
      }
    ) cfg.keyboards;

    hardware.uinput.enable = mkDefault true;

    systemd.services.keyd = {
      description = "Keyd remapping daemon";
      documentation = [ "man:keyd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = mapAttrsToList (
        name: _options: config.environment.etc."keyd/${name}.conf".source
      ) cfg.keyboards;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
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
        CapabilityBoundingSet = [
          "CAP_SYS_NICE"
          "CAP_IPC_LOCK"
        ];
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
