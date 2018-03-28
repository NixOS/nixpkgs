{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitweb;

in
{

  options.services.nginx.gitweb = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, enable gitweb in nginx. Access it at http://yourserver/gitweb
      '';
    };

  };

  config = mkIf config.services.nginx.gitweb.enable {

    systemd.sockets.gitweb = {
      description = "GitWeb Listen Socket";
      listenStreams = [ "/run/gitweb.sock" ];
      socketConfig = {
        Accept = "false";
        SocketUser = "nginx";
        SocketGroup = "nginx";
        SocketMode = "0600";
      };
      wantedBy = [ "sockets.target" ];
    };
    systemd.services.gitweb = {
      description = "GitWeb service";
      script = "${git}/share/gitweb/gitweb.cgi --fcgi";
      serviceConfig = {
        Type = "simple";
        StandardInput = "socket";
        User = "nginx";
        Group = "nginx";
      };
    };

    services.nginx = {
      virtualHosts.default = {
        locations."/gitweb" = {
          root = "${pkgs.git}/share/gitweb";
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param GITWEB_CONFIG ${cfg.gitwebConfigFile};
            fastcgi_pass unix:/run/gitweb.sock;
          '';
        };
      };
    };

  };

  meta.maintainers = with maintainers; [ gnidorah ];

}
