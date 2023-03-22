{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keyd;
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.keyd = {
      enable = mkEnableOption (lib.mdDoc "keyd, a key remapping daemon");

      ids = mkOption {
        type = types.listOf types.string;
        default = [ "*" ];
        example = [ "*" "-0123:0456" ];
        description = lib.mdDoc ''
          Device identifiers, as shown by {manpage}`keyd(1)`.
        '';
      };

      settings = mkOption {
        type = settingsFormat.type;
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
          Configuration, except `ids` section, that is written to {file}`/etc/keyd/default.conf`.
          See <https://github.com/rvaiya/keyd> how to configure.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."keyd/default.conf".source = pkgs.runCommand "default.conf"
      {
        ids = ''
          [ids]
          ${concatStringsSep "\n" cfg.ids}
        '';
        passAsFile = [ "ids" ];
      } ''
      cat $idsPath <(echo) ${settingsFormat.generate "keyd-main.conf" cfg.settings} >$out
    '';

    hardware.uinput.enable = lib.mkDefault true;

    systemd.services.keyd = {
      description = "Keyd remapping daemon";
      documentation = [ "man:keyd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = [
        config.environment.etc."keyd/default.conf".source
      ];

      # this is configurable in 2.4.2, later versions seem to remove this option.
      # post-2.4.2 may need to set makeFlags in the derivation:
      #
      #     makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];
      environment.KEYD_SOCKET = "/run/keyd/keyd.sock";

      serviceConfig = {
        ExecStart = "${pkgs.keyd}/bin/keyd";
        Restart = "always";

        DynamicUser = true;
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];

        RuntimeDirectory = "keyd";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = [
          "char-input rw"
          "/dev/uinput rw"
        ];
        ProtectClock = true;
        PrivateNetwork = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateUsers = true;
        PrivateMounts = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectProc = "noaccess";
        UMask = "0077";
      };
    };
  };
}
