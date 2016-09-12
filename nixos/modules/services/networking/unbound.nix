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

  rootTrustAnchorFile = "${stateDir}/root.key";

  trustAnchor = optionalString cfg.enableRootTrustAnchor
    "auto-trust-anchor-file: ${rootTrustAnchorFile}";

  confFile = pkgs.writeText "unbound.conf" ''
    server:
      directory: "${stateDir}"
      username: unbound
      chroot: "${stateDir}"
      pidfile: ""
      ${interfaces}
      ${access}
      ${trustAnchor}
    ${cfg.extraConfig}
    ${forward}
  '';

in

{

  ###### interface

  options = {
    services.unbound = {

      enable = mkEnableOption "Unbound domain name server";

      allowedAccess = mkOption {
        default = [ "127.0.0.0/24" ];
        type = types.listOf types.str;
        description = "What networks are allowed to use unbound as a resolver.";
      };

      interfaces = mkOption {
        default = [ "127.0.0.1" "::1" ];
        type = types.listOf types.str;
        description = "What addresses the server should listen on.";
      };

      forwardAddresses = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "What servers to forward queries to.";
      };

      enableRootTrustAnchor = mkOption {
        default = true;
        type = types.bool;
        description = "Use and update root trust anchor for DNSSEC validation.";
      };

      extraConfig = mkOption {
        default = "";
        type = types.str;
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
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [" nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -m 0755 -p ${stateDir}/dev/
        cp ${confFile} ${stateDir}/unbound.conf
        ${optionalString cfg.enableRootTrustAnchor ''
        ${pkgs.unbound}/bin/unbound-anchor -a ${rootTrustAnchorFile}
        chown unbound ${stateDir} ${rootTrustAnchorFile}
        ''}
        touch ${stateDir}/dev/random
        ${pkgs.utillinux}/bin/mount --bind -n /dev/random ${stateDir}/dev/random
      '';

      serviceConfig = {
        ExecStart = "${pkgs.unbound}/bin/unbound -d -c ${stateDir}/unbound.conf";
        ExecStopPost="${pkgs.utillinux}/bin/umount ${stateDir}/dev/random";
      };
    };

  };

}
