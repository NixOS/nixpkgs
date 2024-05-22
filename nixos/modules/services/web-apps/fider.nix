{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.fider;
in
{
  options = {
    services.fider = {
      enable = lib.mkEnableOption "the Fider server";
      package = lib.mkPackageOption pkgs "fider" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fider = {
      description = "Fider server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        ${lib.getExe cfg.package} migrate
      '';
      environment = {
        DATABASE_URL = "postgres://fider_ci:fider_ci_pw@postgres:5432/fider_ci?sslmode=disable";
        JWT_SECRET = "not_so_secret";
        BASE_URL = "/";
        EMAIL_NOREPLY = "noreply@fider.io";
        EMAIL_SMTP_HOST = "mailhog";
        EMAIL_SMTP_PORT = "1025";
      };
      serviceConfig = {
        ExecStart = ''${lib.getExe cfg.package}'';
        StateDirectory = "fider";
        DynamicUser = true;
        PrivateTmp = "yes";
        Restart = "on-failure";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ drupol ];
    # doc = ./fider.md;
  };
}
