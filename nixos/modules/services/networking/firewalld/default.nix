{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.firewalld;
  paths = pkgs.buildEnv {
    name = "firewalld-paths";
    paths = cfg.packages;
    pathsToLink = [ "/lib/firewalld" ];
  };
in
{
  imports = [
    ./service.nix
    ./settings.nix
    ./zone.nix
  ];

  options.services.firewalld = {
    enable = lib.mkEnableOption "FirewallD";
    package = lib.mkPackageOption pkgs "firewalld" { };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Packages providing firewalld zones and other files.
        Files found in `/lib/firewalld` will be included.
      '';
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--debug" ];
      description = "Extra arguments to pass to FirewallD.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    services.firewalld.packages = [ cfg.package ];

    services.logrotate.settings."/var/log/firewalld" = {
      copytruncate = true;
      minsize = "1M";
    };

    environment.etc."sysconfig/firewalld".text = ''
      FIREWALLD_ARGS=${lib.concatStringsSep " " cfg.extraArgs}
    '';

    systemd.packages = [ cfg.package ];
    systemd.services.firewalld = {
      aliases = [ "dbus-org.fedoraproject.FirewallD1.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
      environment.NIX_FIREWALLD_CONFIG_PATH = "${paths}/lib/firewalld";
    };
  };

  meta.maintainers = with lib.maintainers; [ prince213 ];
}
