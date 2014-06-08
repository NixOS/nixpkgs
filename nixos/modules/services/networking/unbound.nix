{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.unbound;

  username = "unbound";

  stateDir = "/var/lib/unbound";

  access = concatMapStrings (x: "  access-control: ${x} allow\n") cfg.allowedAccess;

  interfaces = concatMapStrings (x: "  interface: ${x}\n") cfg.interfaces;

  forward = optionalString (length cfg.forwardAddresses != 0)
    "forward-zone:\n  name: .\n" +
    concatMapStrings (x: "  forward-addr: ${x}\n") cfg.forwardAddresses;

  confFile = pkgs.writeText "unbound.conf" ''
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
	description = "Whether to enable the Unbound domain name server.";
      };

      allowedAccess = mkOption {
	default = ["127.0.0.0/24"];
	description = "What networks are allowed to use unbound as a resolver.";
      };

      interfaces = mkOption {
	default = [ "127.0.0.1" "::1" ];
	description = "What addresses the server should listen on.";
      };

      forwardAddresses = mkOption {
	default = [ ];
	description = "What servers to forward queries to.";
      };

      extraConfig = mkOption {
	default = "";
	description = "Extra lines of unbound config.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.unbound ];

    users.extraUsers = singleton {
      name = username;
      uid = config.ids.uids.unbound;
      description = "unbound daemon user";
      home = stateDir;
      createHome = true;
    };

    systemd.services.unbound = {
      description="Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [" nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.unbound ];
      serviceConfig.ExecStart = "${pkgs.unbound}/sbin/unbound -d -c ${confFile}";
    };

  };

}
