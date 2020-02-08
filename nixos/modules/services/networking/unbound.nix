{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.unbound;

  stateDir = "/var/lib/unbound";

  access = concatMapStringsSep "\n  " (x: "access-control: ${x} allow") cfg.allowedAccess;

  interfaces = concatMapStringsSep "\n  " (x: "interface: ${x}") cfg.interfaces;

  isLocalAddress = x: substring 0 3 x == "::1" || substring 0 9 x == "127.0.0.1";

  remote =
    optionalString (cfg.enableRemoteAccess) ''
    remote-control:
      control-enable: "yes"
      server-key-file: ${stateDir}/unbound_server.key
      server-cert-file: ${stateDir}/unbound_server.pem
      control-key-file: ${stateDir}/unbound_control.key
      control-cert-file: ${stateDir}/unbound_control.pem
      control-port: ${toString cfg.remoteAccessPort}
      ${concatMapStringsSep "\n  " (x: "control-interface: ${x}") cfg.remoteAccessInterfaces}
    '';

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

  unboundWrapped = pkgs.stdenv.mkDerivation {
      name = "unbound-wrapped";

      buildInputs = [ pkgs.makeWrapper pkgs.unbound ];

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p "$out/bin"
        makeWrapper ${pkgs.unbound}/bin/unbound-control $out/bin/unbound-control \
          --add-flags "-c ${stateDir}/unbound.conf"
        makeWrapper ${pkgs.unbound}/bin/unbound-checkconf $out/bin/unbound-checkconf \
          --add-flags "${stateDir}/unbound.conf"
      '';
    };

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
    ${remote}
  '';

in

{

  ###### interface

  options = {
    services.unbound = {

      enable = mkEnableOption "Unbound domain name server";

      package = mkOption {
        type = types.package;
        default = pkgs.unbound;
        defaultText = "pkgs.unbound";
        description = "The unbound package to use";
      };

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

      enableRemoteAccess = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Sets the remote-control option to 'yes' in the config and generates keys + certificates under ${stateDir}
          with <literal>unbound-control-setup</literal>.
          Sets the default addresses to <literal>127.0.0.1</literal> <literal>::1</literal> and port <literal>8953</literal>.
          Interfaces the server listens to can be set with <literal>remoteAccessInterfaces</literal>.
          The port can be set with <literal>remoteAccessPort</literal>.
          NOTE: This option doesn't open any ports.
        '';
      };

      remoteAccessInterfaces = mkOption {
        default = [ "127.0.0.1" ] ++ optional config.networking.enableIPv6 "::1";
        type = types.listOf types.str;
        description = ''
          What addresses/interfaces are allowed to remote-control the unbound server.
          Requires <literal>enableRemoteAccess</literal> set to true.
        '';
      };

      remoteAccessPort = mkOption {
        default = 8953;
        type = types.port;
        description = ''
          What port the unbound server will listen on for remote-control.
          Requires <literal>enableRemoteAccess</literal> set to true.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package (hiPrio unboundWrapped) ];

    users.users.unbound = {
      description = "unbound daemon user";
      isSystemUser = true;
    };

    networking.resolvconf.useLocalResolver = mkDefault true;

    systemd.services.unbound = {
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      path = mkIf cfg.enableRemoteAccess [ pkgs.openssl ];

      preStart = ''
        mkdir -m 0755 -p ${stateDir}/dev/
        cp ${confFile} ${stateDir}/unbound.conf
        ${optionalString cfg.enableRootTrustAnchor ''
          ${cfg.package}/bin/unbound-anchor -a ${rootTrustAnchorFile} || echo "Root anchor updated!"
          chown unbound ${stateDir} ${rootTrustAnchorFile}
        ''}
        touch ${stateDir}/dev/random
        ${pkgs.utillinux}/bin/mount --bind -n /dev/urandom ${stateDir}/dev/random
        ${optionalString cfg.enableRemoteAccess "${pkgs.unbound}/bin/unbound-control-setup -d ${stateDir}"}
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/unbound -d -c ${stateDir}/unbound.conf";
        ExecStopPost = "${pkgs.utillinux}/bin/umount ${stateDir}/dev/random";

        ProtectSystem = true;
        ProtectHome = true;
        PrivateDevices = true;
        Restart = "always";
        RestartSec = "5s";
      };
    };

    # If networkmanager is enabled, ask it to interface with unbound.
    networking.networkmanager.dns = "unbound";

  };

}
