{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.virtlyst;
  stateDir = "/var/lib/virtlyst";

  ini = pkgs.writeText "virtlyst-config.ini" ''
    [wsgi]
    master = true
    threads = auto
    http-socket = ${cfg.httpSocket}
    application = ${pkgs.virtlyst}/lib/libVirtlyst.so
    chdir2 = ${stateDir}
    static-map = /static=${pkgs.virtlyst}/root/static

    [Cutelyst]
    production = true
    DatabasePath = virtlyst.sqlite
    TemplatePath = ${pkgs.virtlyst}/root/src

    [Rules]
    cutelyst.* = true
    virtlyst.* = true
  '';

in

{

  options.services.virtlyst = {
    enable = mkEnableOption "Virtlyst libvirt web interface";

    adminPassword = mkOption {
      type = types.str;
      description = ''
        Initial admin password with which the database will be seeded.
      '';
    };

    httpSocket = mkOption {
      type = types.str;
      default = "localhost:3000";
      description = ''
        IP and/or port to which to bind the http socket.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.virtlyst = {
      home = stateDir;
      createHome = true;
      group = mkIf config.virtualisation.libvirtd.enable "libvirtd";
    };

    systemd.services.virtlyst = {
      wantedBy = [ "multi-user.target" ];
      environment = {
        VIRTLYST_ADMIN_PASSWORD = cfg.adminPassword;
      };
      serviceConfig = {
        ExecStart = "${pkgs.cutelyst}/bin/cutelyst-wsgi2 --ini ${ini}";
        User = "virtlyst";
        WorkingDirectory = stateDir;
      };
    };
  };

}
