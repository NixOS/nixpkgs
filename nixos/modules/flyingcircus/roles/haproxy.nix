{ config, lib, pkgs, ... }: with lib;

let
  nonEmptyString = string: if lib.stringLength string > 0 then true else false;
  configFromFile = file: default: lib.findFirst (nonEmptyString) default [
    (if (builtins.pathExists file)
     then builtins.readFile file
     else "")
  ];

  haproxyCfg = configFromFile /etc/haproxy/haproxy.cfg ''
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

    jobs.fcio-stubs-haproxy = {
      description = "Create FC IO stubs haproxy";
      task = true;

      startOn = "started networking";

      script = ''
        mkdir -p /etc/haproxy
        test -L  /etc/haproxy.cfg || ln -s /etc/haproxy/haproxy.cfg /etc/haproxy.cfg
        chown -R vagrant: /etc/haproxy.cfg /etc/haproxy
      '';
    };

  };

}
