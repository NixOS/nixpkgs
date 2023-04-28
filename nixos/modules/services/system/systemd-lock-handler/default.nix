{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.systemd-lock-handler;
in {
  options.services.systemd-lock-handler = {
    enable = mkEnableOption (lib.mdDoc "systemd-lock-handler");
    package = mkOption {
      default = pkgs.systemd-lock-handler;
      defaultText = literalExpression "pkgs.systemd-lock-handler";
      type = types.package;
      description = lib.mdDoc "systemd-lock-handler package to use.";
    };
    config = mkIf cfg.enable {
      systemd.user.services.systemd-lock-handler = {
        description = "Logind lock event to systemd target translation";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Documentation = "https://sr.ht/~whynothugo/systemd-lock-handler";
          Slice = [ "session.slice" ];
          ExecStart = "${cfg.package}/bin/systemd-lock-handler";
          Type = "notify";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
  };
}
