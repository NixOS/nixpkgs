{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.gotify;
in
{
  options.services.gotify = {
    enable = lib.mkEnableOption "Gotify webserver";

    package = lib.mkPackageOption pkgs "gotify-server" { };

    port = lib.mkOption {
      type = lib.types.port;
      description = ''
        Port the server listens to.
      '';
    };

    stateDirectoryName = lib.mkOption {
      type = lib.types.str;
      default = "gotify-server";
      description = ''
        The name of the directory below {file}`/var/lib` where
        gotify stores its runtime data.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gotify-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Simple server for sending and receiving messages";

      environment = {
        GOTIFY_SERVER_PORT = toString cfg.port;
      };

      serviceConfig = {
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        StateDirectory = cfg.stateDirectoryName;
        Restart = "always";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ DCsunset ];
}
