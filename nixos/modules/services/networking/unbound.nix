{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.unbound;

  stateDir = "/var/lib/unbound";

  access = concatMapStringsSep "\n  " (x: "access-control: ${x} allow") cfg.allowedAccess;

  interfaces = concatMapStringsSep "\n  " (x: "interface: ${x}") cfg.interfaces;

  isLocalAddress = x: substring 0 3 x == "::1" || substring 0 9 x == "127.0.0.1";

  forward =
    optionalString (any isLocalAddress cfg.forwardAddresses) ''
      do-not-query-localhost: no
    '' +
    optionalString (cfg.forwardAddresses != []) ''
      forward-zone:
        name: .
    '' +
    optionalString cfg.forwardTlsUpstream
    "  forward-tls-upstream: yes\n" +
    concatMapStringsSep "\n" (x: "  forward-addr: ${x}") cfg.forwardAddresses;

  rootTrustAnchorFile = "${stateDir}/root.key";

  trustAnchor = optionalString cfg.enableRootTrustAnchor
    "auto-trust-anchor-file: ${rootTrustAnchorFile}";
  tlsCertBundle = optionalString cfg.forwardTlsUpstream
    "tls-cert-bundle: ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  remoteControlConfig = with cfg.remoteControl; ''
    remote-control:
      control-enable: yes
      control-interface: ${interface}
      control-port: ${builtins.toString port}
      server-key-file: "${stateDir}/unbound_server.key"
      server-cert-file: "${stateDir}/unbound_server.pem"
      control-key-file: "${stateDir}/unbound_control.key"
      control-cert-file: "${stateDir}/unbound_control.pem"
  '';

  rootHints = optionalString (cfg.rootHints != null)
    "root-hints: \"${stateDir}/root.hints\"";

  confFile = pkgs.writeText "unbound.conf" ''
    server:
      directory: "${stateDir}"
      username: unbound
      chroot: "${stateDir}"
      pidfile: ""
      ${interfaces}
      ${access}
      ${trustAnchor}
      ${tlsCertBundle}
      ${rootHints}
    ${optionalString cfg.remoteControl.enable remoteControlConfig}
    ${cfg.extraConfig}
    ${forward}
  '';

  preStartScript =  ''
    mkdir -m 0755 -p ${stateDir}/dev/
    cp ${confFile} ${stateDir}/unbound.conf
    ${optionalString (cfg.rootHints != null) ''
      cp ${cfg.rootHints} ${stateDir}/root.hints
    ''}
    ${optionalString cfg.enableRootTrustAnchor ''
      ${pkgs.unbound}/bin/unbound-anchor -a ${rootTrustAnchorFile} || echo "Root anchor updated!"
      chown unbound ${stateDir} ${rootTrustAnchorFile}
    ''}
    ${optionalString cfg.remoteControl.enable ''
      ${pkgs.unbound}/bin/unbound-control-setup -d ${stateDir} || echo "Unbound remote control certificates generated!"
      chown unbound ${stateDir}/unbound_server.key ${stateDir}/unbound_server.pem ${stateDir}/unbound_control.key ${stateDir}/unbound_control.pem
    ''}
    touch ${stateDir}/dev/random
    ${pkgs.utillinux}/bin/mount --bind -n /dev/urandom ${stateDir}/dev/random
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
        default = [ "127.0.0.1" ] ++ optional config.networking.enableIPv6 "::1";
        type = types.listOf types.str;
        description = "What addresses the server should listen on.";
      };

      forwardAddresses = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "What servers to forward queries to.";
      };

      forwardTlsUpstream = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to forward NSSEC upstream";
      };

      enableRootTrustAnchor = mkOption {
        default = true;
        type = types.bool;
        description = "Use and update root trust anchor for DNSSEC validation.";
      };

      rootHints = mkOption {
        type = types.nullOr types.path;
        description = "Root hints file to replace default";
      };

      remoteControl = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable the remote control feature";
        };

        interface = mkOption {
          type = types.string;
          default = "127.0.0.1";
          description = "Interface to listen on for remote control requests. You probably do not want this exposed to the internet";
        };

        port = mkOption {
          type = types.int;
          default = 8953;
          description = "Port to listen on for remote control";
        };
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

      preStart = preStartScript;

      path = [ pkgs.openssl_1_1 ];

      serviceConfig = {
        ExecStart = "${pkgs.unbound}/bin/unbound -d -c ${stateDir}/unbound.conf";
        ExecStopPost="${pkgs.utillinux}/bin/umount ${stateDir}/dev/random";

        ProtectSystem = true;
        ProtectHome = true;
        PrivateDevices = true;
        Restart = "always";
        RestartSec = "5s";
      };
    };

    runit.services.unbound = {
      logging.enable = true;
      logging.redirectStderr = true;
      requires = [ "network" ];
      path = [ pkgs.openssl_1_1 ];
      script = ''
        ${preStartScript}

        exec ${pkgs.unbound}/bin/unbound -dd -c ${stateDir}/unbound.conf
      '';

      stop = ''
        ${pkgs.utillinux}/bin/umount ${stateDir}/dev/random
      '';
    };

    # If networkmanager is enabled, ask it to interface with unbound.
    networking.networkmanager.dns = "unbound";

  };

}
