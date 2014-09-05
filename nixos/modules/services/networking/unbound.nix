{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.unbound;

  stateDir = "/var/lib/unbound";

  access = concatMapStrings (x: "  access-control: ${x} allow\n") cfg.allowedAccess;

  interfaces = concatMapStrings (x: "  interface: ${x}\n") cfg.interfaces;

  forward = optionalString (length cfg.forwardAddresses != 0)
    "forward-zone:\n  name: .\n" +
    concatMapStrings (x: "  forward-addr: ${x}\n") cfg.forwardAddresses;

  confFile = pkgs.writeText "unbound.conf" ''
    server:
      directory: "${stateDir}"
      username: unbound
      chroot: "${stateDir}"
      pidfile: ""
      ${interfaces}
      ${access}
    ${cfg.extraConfig}
    ${forward}
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
      name = "unbound";
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

      preStart = ''
        mkdir -m 0755 -p ${stateDir}/dev/
	cp ${confFile} ${stateDir}/unbound.conf
	chown unbound ${stateDir}
	touch ${stateDir}/dev/random
        ${pkgs.utillinux}/bin/mount --bind -n /dev/random ${stateDir}/dev/random
      '';

      serviceConfig = {
        ExecStart = "${pkgs.unbound}/sbin/unbound -d -c ${stateDir}/unbound.conf";
        ExecStopPost="${pkgs.utillinux}/bin/umount ${stateDir}/dev/random";
      };
    };

  };

}
