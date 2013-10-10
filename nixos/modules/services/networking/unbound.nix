{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.unbound;

  username = "unbound";

  stateDir = "/var/lib/unbound";

  access = concatMapStrings (x: "  access-control: ${x} allow\n") cfg.allowedAccess;

  interfaces = concatMapStrings (x: "  interface: ${x}\n") cfg.interfaces;

  forward = optionalString (length cfg.forwardAddresses != 0)
    "forward-zone:\n  name: .\n" +
    concatMapStrings (x: "  forward-addr: ${x}\n") cfg.forwardAddresses;

  confFile = pkgs.writeText "unbound.conf"
    ''
      server:
        directory: "${stateDir}"
        username: ${username}
        # make sure unbound can access entropy from inside the chroot.
        # e.g. on linux the use these commands (on BSD, devfs(8) is used):
        #      mount --bind -n /dev/random /etc/unbound/dev/random
        # and  mount --bind -n /dev/log /etc/unbound/dev/log
        chroot: "${stateDir}"
        # logfile: "${stateDir}/unbound.log"  #uncomment to use logfile.
        pidfile: "${stateDir}/unbound.pid"
        verbosity: 1      # uncomment and increase to get more logging.
        # listen on all interfaces, answer queries from the local subnet.
      ${interfaces}
      ${access}
      ${forward}
      ${cfg.extraConfig}
    '';

in

{

  ###### interface

  options = {

    services.unbound = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the Unbound domain name server.
        ";
      };

      allowedAccess = mkOption {
        default = ["127.0.0.0/24"];
        description = "
          What networks are allowed to use us as a resolver.
        ";
      };

      interfaces = mkOption {
        default = [ "127.0.0.0" "::1" ];
        description = "
          What addresses the server should listen to.
        ";
      };

      forwardAddresses = mkOption {
        default = [ ];
        description = "
          What servers to forward the queries to.
        ";
      };

      extraConfig = mkOption {
        default = "";
        description = "
          Extra unbound config
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.unbound.enable {
    environment.systemPackages = [ pkgs.unbound ];

    users.extraUsers = singleton
      { name = username;
        uid = config.ids.uids.unbound;
        description = "unbound daemon user";
        home = "/tmp";
      };

    jobs.unbound =
      { description = "Unbound name server job";

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -p ${stateDir}
          '';

        daemonType = "fork";

        exec = "${pkgs.unbound}/sbin/unbound -c ${confFile}";
      };

  };

}
