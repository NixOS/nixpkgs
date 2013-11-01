{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) privoxy;

  stateDir = "/var/spool/privoxy";

  privoxyUser = "privoxy";

  privoxyFlags = "--no-daemon --user ${privoxyUser} ${privoxyCfg}";

  privoxyCfg = pkgs.writeText "privoxy.conf" ''
    listen-address  ${config.services.privoxy.listenAddress}
    logdir          ${config.services.privoxy.logDir}
    confdir         ${privoxy}/etc
    filterfile      default.filter

    ${config.services.privoxy.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.privoxy = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the machine as a HTTP proxy server.
        '';
      };

      listenAddress = mkOption {
        default = "127.0.0.1:8118";
        description = ''
          Address the proxy server is listening to.
        '';
      };

      logDir = mkOption {
        default = "/var/log/privoxy" ;
        description = ''
          Location for privoxy log files.
        '';
      };

      extraConfig = mkOption {
        default = "" ;
        description = ''
          Extra configuration. Contents will be added verbatim to the configuration file.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.privoxy.enable {
  
    environment.systemPackages = [ privoxy ];

    users.extraUsers = singleton
      { name = privoxyUser;
        uid = config.ids.uids.privoxy;
        description = "Privoxy daemon user";
        home = stateDir;
      };

    jobs.privoxy =
      { name = "privoxy";

        startOn = "startup";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${privoxyUser} ${stateDir}
          '';

        exec = "${privoxy}/sbin/privoxy ${privoxyFlags}";
      };

  };

}
