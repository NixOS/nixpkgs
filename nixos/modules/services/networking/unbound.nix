{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.unbound;

  stateDir = "/var/lib/unbound";

  access = concatMapStrings (x: "  access-control: ${x} allow\n") cfg.allowedAccess;

  interfaces = concatMapStrings (x: "  interface: ${x}\n") cfg.interfaces;

  isLocalAddress = x: substring 0 3 x == "::1" || substring 0 9 x == "127.0.0.1";

  forward =
    optionalString (any isLocalAddress cfg.forwardAddresses) ''
      do-not-query-localhost: no
    '' +
    optionalString (cfg.forwardAddresses != []) ''
      forward-zone:
        name: .
    '' +
    concatMapStringsSep "\n" (x: "    forward-addr: ${x}") cfg.forwardAddresses;

  rootTrustAnchorFile = "${stateDir}/root.key";

  trustAnchor = optionalString cfg.enableRootTrustAnchor
    "auto-trust-anchor-file: ${rootTrustAnchorFile}";

  confFile = pkgs.writeText "unbound.conf" ''
    remote-control:
      server-key-file: "${stateDir}/unbound_server.key"
      server-cert-file: "${stateDir}/unbound_server.pem"
      control-key-file: "${stateDir}/unbound_control.key"
      control-cert-file: "${stateDir}/unbound_control.pem"
    server:
      directory: "${stateDir}"
      username: unbound
      chroot: ""
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
        type = types.lines;
        description = ''
          Extra unbound config. See
          <citerefentry><refentrytitle>unbound.conf</refentrytitle><manvolnum>8
          </manvolnum></citerefentry>.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.unbound ];

    users.users.unbound = {
      description = "unbound daemon user";
      isSystemUser = true;
    };

    systemd.services.unbound = {
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.openssl ];

      preStart = ''
        mkdir -m 0755 -p ${stateDir}/dev/
        cp ${confFile} ${stateDir}/unbound.conf

        ${optionalString cfg.enableRootTrustAnchor ''
        ${pkgs.unbound}/bin/unbound-anchor -a ${rootTrustAnchorFile}
        chown unbound ${stateDir} ${rootTrustAnchorFile}
        ''}

        if [ ! -f ${stateDir}/.control_keys_generated ]; then
          ${pkgs.unbound}/bin/unbound-control-setup -d ${stateDir}
          touch ${stateDir}/.control_keys_generated
        fi

        touch ${stateDir}/dev/random
        ${pkgs.utillinux}/bin/mount --bind -n /dev/urandom ${stateDir}/dev/random
      '';

      restartTriggers = [ confFile ];
      reloadIfChanged = true;
      reload = ''
        cp ${confFile} ${stateDir}/unbound.conf
        ${pkgs.coreutils}/bin/kill -HUP $MAINPID
      '';

      serviceConfig = {
        ExecStart = "${pkgs.unbound}/bin/unbound -d -c ${stateDir}/unbound.conf";
        ExecStopPost="${pkgs.utillinux}/bin/umount ${stateDir}/dev/random";

        ProtectSystem = true;
        ProtectHome = true;
        PrivateDevices = true;
      };
    };

  };

}
