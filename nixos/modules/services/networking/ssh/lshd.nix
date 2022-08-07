{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) lsh;

  cfg = config.services.lshd;

in

{

  ###### interface

  options = {

    services.lshd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the GNU lshd SSH2 daemon, which allows
          secure remote login.
        '';
      };

      portNumber = mkOption {
        default = 22;
        type = types.port;
        description = lib.mdDoc ''
          The port on which to listen for connections.
        '';
      };

      interfaces = mkOption {
        default = [];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          List of network interfaces where listening for connections.
          When providing the empty list, `[]', lshd listens on all
          network interfaces.
        '';
        example = [ "localhost" "1.2.3.4:443" ];
      };

      hostKey = mkOption {
        default = "/etc/lsh/host-key";
        type = types.str;
        description = lib.mdDoc ''
          Path to the server's private key.  Note that this key must
          have been created, e.g., using "lsh-keygen --server |
          lsh-writekey --server", so that you can run lshd.
        '';
      };

      syslog = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable syslog output.";
      };

      passwordAuthentication = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable password authentication.";
      };

      publicKeyAuthentication = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable public key authentication.";
      };

      rootLogin = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable remote root login.";
      };

      loginShell = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          If non-null, override the default login shell with the
          specified value.
        '';
        example = "/nix/store/xyz-bash-10.0/bin/bash10";
      };

      srpKeyExchange = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to enable SRP key exchange and user authentication.
        '';
      };

      tcpForwarding = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable TCP/IP forwarding.";
      };

      x11Forwarding = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable X11 forwarding.";
      };

      subsystems = mkOption {
        type = types.listOf types.path;
        description = lib.mdDoc ''
          List of subsystem-path pairs, where the head of the pair
          denotes the subsystem name, and the tail denotes the path to
          an executable implementing it.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.lshd.subsystems = [ ["sftp" "${pkgs.lsh}/sbin/sftp-server"] ];

    systemd.services.lshd = {
      description = "GNU lshd SSH2 daemon";

      after = [ "network.target" ];

      wantedBy = [ "multi-user.target" ];

      environment = {
        LD_LIBRARY_PATH = config.system.nssModules.path;
      };

      preStart = ''
        test -d /etc/lsh || mkdir -m 0755 -p /etc/lsh
        test -d /var/spool/lsh || mkdir -m 0755 -p /var/spool/lsh

        if ! test -f /var/spool/lsh/yarrow-seed-file
        then
            # XXX: It would be nice to provide feedback to the
            # user when this fails, so that they can retry it
            # manually.
            ${lsh}/bin/lsh-make-seed --sloppy \
               -o /var/spool/lsh/yarrow-seed-file
        fi

        if ! test -f "${cfg.hostKey}"
        then
            ${lsh}/bin/lsh-keygen --server | \
            ${lsh}/bin/lsh-writekey --server -o "${cfg.hostKey}"
        fi
      '';

      script = with cfg; ''
        ${lsh}/sbin/lshd --daemonic \
          --password-helper="${lsh}/sbin/lsh-pam-checkpw" \
          -p ${toString portNumber} \
          ${if interfaces == [] then ""
            else (concatStrings (map (i: "--interface=\"${i}\"")
                                     interfaces))} \
          -h "${hostKey}" \
          ${if !syslog then "--no-syslog" else ""} \
          ${if passwordAuthentication then "--password" else "--no-password" } \
          ${if publicKeyAuthentication then "--publickey" else "--no-publickey" } \
          ${if rootLogin then "--root-login" else "--no-root-login" } \
          ${if loginShell != null then "--login-shell=\"${loginShell}\"" else "" } \
          ${if srpKeyExchange then "--srp-keyexchange" else "--no-srp-keyexchange" } \
          ${if !tcpForwarding then "--no-tcpip-forward" else "--tcpip-forward"} \
          ${if x11Forwarding then "--x11-forward" else "--no-x11-forward" } \
          --subsystems=${concatStringsSep ","
                                          (map (pair: (head pair) + "=" +
                                                      (head (tail pair)))
                                               subsystems)}
      '';
    };

    security.pam.services.lshd = {};
  };
}
