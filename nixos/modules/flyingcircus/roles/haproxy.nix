{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;

  nonEmptyString = string: (lib.stringLength string > 0);
  configFromFile = file: default:
    lib.findFirst (nonEmptyString) default [
      (if (builtins.pathExists file)
       then builtins.readFile file
       else "")
  ];

  haproxyCfg = configFromFile /etc/local/haproxy/haproxy.cfg ''
    frontend http
    bind 127.0.0.1:8002
  '';

in

{

  options = {

    flyingcircus.roles.haproxy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus haproxy server role.";
      };

    };

  };

  config = mkIf config.flyingcircus.roles.haproxy.enable {

    services.haproxy.enable = true;
    services.haproxy.config = haproxyCfg;
    system.activationScripts.haproxy = ''
      install -d -o ${toString config.ids.uids.haproxy} -g service -m 02775 /etc/local/haproxy
    '';

    environment.etc = {
      "local/haproxy/README.txt".text = ''
        HAProxy is enabled on this machine.

        Put your haproxy configuration here as `haproxy.cfg`. There is also
        an `example-configuration` here.
      '';
      "local/haproxy/example-configuration".text = ''
      # haproxy configuration example - copy to haproxy.cfg and adapt.

      global
          daemon
          chroot /var/empty
          user haproxy
          group haproxy
          maxconn 4096

      defaults
          mode http
          log global
          option httplog
          option dontlognull
          option http-server-close
          timeout connect 5s
          timeout client 30s    # should be equal to server timeout
          timeout server 30s    # should be equal to client timeout
          timeout queue 25s   # discard requests sitting too long in the queue

      listen http-in
          bind 127.0.0.1:8002
          bind ::1:8002

      '';
      "haproxy.cfg" = {
        source = /etc/local/haproxy/haproxy.cfg;
        enable = cfg.compat.gentoo.enable;
      };
      "haproxy" = {
        source = /etc/local/haproxy;
        enable = cfg.compat.gentoo.enable;
      };
    };
  };

}
