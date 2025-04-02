{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.robustirc-bridge;
in
{
  options = {
    services.robustirc-bridge = {
      enable = mkEnableOption "RobustIRC bridge";

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''Extra flags passed to the {command}`robustirc-bridge` command. See [RobustIRC Documentation](https://robustirc.net/docs/adminguide.html#_bridge) or robustirc-bridge(1) for details.'';
        example = [
          "-network robustirc.net"
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.robustirc-bridge = {
      description = "RobustIRC bridge";
      documentation = [
        "man:robustirc-bridge(1)"
        "https://robustirc.net/"
      ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.robustirc-bridge}/bin/robustirc-bridge ${concatStringsSep " " cfg.extraFlags}";
        Restart = "on-failure";

        # Hardening
        PrivateDevices = true;
        ProtectSystem = true;
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };
}
