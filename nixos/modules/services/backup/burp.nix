{ config, lib, pkgs, ... }:

with lib;

let
  libDir = "/var/lib/burp";

  cfg = config.services.burp;
  burp_conf = pkgs.writeText "burp.conf" ''
    mode = client
    pidfile = /run/burp/burp.pid

    port = ${toString cfg.client.port}
    status_port = ${toString cfg.client.status_port}
    server = ${cfg.client.server}
    password = ${cfg.client.password}
    cname = ${cfg.client.cname}
    protocol = ${toString cfg.client.protocol}

    ca_burp_ca = ${pkgs.burp}/bin/burp_ca
    ca_csr_dir = ${cfg.client.ca_csr_dir}
    ssl_cert_ca = ${cfg.client.ssl_cert_ca}
    ssl_cert = ${cfg.client.ssl_cert}
    ssl_key = ${cfg.client.ssl_key}
    ssl_key_password = ${cfg.client.ssl_key_password}
    ssl_peer_cn = ${cfg.client.ssl_peer_cn}

    ${concatMapStringsSep "\n" (x: "include = " + x) cfg.client.includes}

    ${concatMapStringsSep "\n" (x: "exclude = " + x) cfg.client.excludes}

    nobackup = ${cfg.client.nobackup}

    ${cfg.client.extraConfig}
  '';

  burp_server_conf = pkgs.writeText "burp-server.conf" ''
    mode = server
    pidfile = /run/burp/burp.server.pid

    user = ${cfg.server.user}
    group = ${cfg.server.group}

    clientconfdir = ${cfg.server.clientconfdir}
    ${concatMapStringsSep "\n" (x: "address = " + x) cfg.server.addresses}
    port = ${toString cfg.server.port}
    status_port = ${toString cfg.server.status_port}
    directory = ${cfg.server.directory}
    protocol = ${toString cfg.server.protocol}
    hardlinked_archive = ${toString cfg.server.hardlinked_archive}
    working_dir_recovery_method = ${cfg.server.working_dir_recovery_method}
    umask = ${toString cfg.server.umask}

    client_can_delete = ${toString cfg.server.client_can_delete}
    client_can_force_backup = ${toString cfg.server.client_can_force_backup}
    client_can_list = ${toString cfg.server.client_can_list}
    client_can_restore = ${toString cfg.server.client_can_restore}
    client_can_verify = ${toString cfg.server.client_can_verify}

    ca_conf = ${cfg.server.ca_conf}
    ca_name = ${cfg.server.ca_name}
    ca_server_name = ${cfg.server.ca_server_name}
    ca_burp_ca = ${pkgs.burp}/bin/burp_ca

    ca_crl_check = ${toString cfg.server.ca_crl_check}
    ssl_cert_ca = ${cfg.server.ssl_cert_ca}
    ssl_cert = ${cfg.server.ssl_cert}
    ssl_key = ${cfg.server.ssl_key}
    ssl_dhfile = ${cfg.server.ssl_dhfile}
    ssl_key_password = ${cfg.server.ssl_key_password}
    ssl_peer_cn = ${cfg.server.ssl_peer_cn}

    ${concatMapStringsSep "\n" (x: "keep = " + toString x) cfg.server.keeps}

    timer_script = ${cfg.server.timer_script}
    ${concatMapStringsSep "\n" (x: "timer_arg = " + x) cfg.server.timer_args}

    ${cfg.server.extraConfig}
  '';

in {
  options = {
    services.burp.client = {
      enable = mkEnableOption "BURP client";

      frequency = mkOption {
        type = types.str;
        default = "hourly";
        description = ''
          Controls how frequently the systemd timer is triggered and a backup
          is attempted.
          Backup frequency is still determined by the server, this
          controls only how often the client tries.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 4971;
        description = ''
          Port used for backup communication
        '';
      };

      status_port = mkOption {
        type = types.int;
        default = 4972;
        description = ''
          Port used for querying backup and server status
        '';
      };

      server = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Address of burp server the client should contact
        '';
      };

      cname = mkOption {
        type = types.str;
        default = "${config.networking.hostName}-nixos";
        description = ''
          Name the client should use to identify itself on the server
        '';
      };

      protocol = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Protocol used for server-client communication and backup
        '';
      };

      password = mkOption {
        type = types.str;
        default = "change-this-password";
        description = ''
          Password used by the client for first contact with the server
        '';
      };

      ca_burp_ca = mkOption {
        type = types.str;
        default = "${pkgs.burp}/bin/burp_ca";
        description = ''
          Location of burp binary used to generate client/server certificates
        '';
      };

      ca_csr_dir = mkOption {
        type = types.str;
        default = "${libDir}/CA-client";
        description = ''
          Location of client CA certificates
        '';
      };

      ssl_cert_ca = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert_ca.pem";
        description = ''
          Location of client SSL certificate authority -
          should refer to the same file on server and client
        '';
      };

      ssl_cert = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert-client.pem";
        description = ''
          Location of client SSL certificate
        '';
      };

      ssl_key = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert-client.key";
        description = ''
          Location of client SSL key
        '';
      };

      ssl_key_password = mkOption {
        type = types.str;
        default = "change-this-password";
        description = ''
          SSL key password, for loading a certificate with encryption.
        '';
      };

      ssl_peer_cn = mkOption {
        type = types.str;
        default = "burpserver";
        description = ''
          Common name in the certificate that the server gives the client
        '';
      };

      includes = mkOption {
        type = types.listOf types.str;
        default = [ "/etc" "/root" "/var" "/home" ];
        description = ''
          Which locations to include in backup
        '';
      };

      excludes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Which locations to exclude from backup
        '';
      };

      nobackup = mkOption {
        type = types.str;
        default = ".nobackup";
        description = ''
          Exclude folders containing a file with name
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for burp client. Contents will be added verbatim to the
          configuration file.
        '';
      };
    };

    services.burp.server = {
      enable = mkEnableOption "BURP server";

      user = mkOption {
        type = types.str;
        default = "burp";
        description = ''
          Run server as user
        '';
      };

      group = mkOption {
        type = types.str;
        default = "burp";
        description = ''
          Run server as group
        '';
      };

      clientconfdir = mkOption {
        type = types.str;
        default = "${libDir}/clientconfdir";
        description = ''
          Location of client configuration files
        '';
      };

      addresses = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        description = ''
          Addresses to listen on
        '';
      };

      port = mkOption {
        type = types.int;
        default = 4971;
        description = ''
          Port used for backup communication
        '';
      };

      status_port = mkOption {
        type = types.int;
        default = 4972;
        description = ''
          Port used for querying backup and server status
        '';
      };

      directory = mkOption {
        type = types.str;
        default = "/var/spool/burp";
        description = ''
          Backup storage location
        '';
      };

      protocol = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Protocol used for server-client communication and backup
        '';
      };

      hardlinked_archive = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Hardlink backup archives - saves storage at the cost of slightly longer post-processing
        '';
      };

      working_dir_recovery_method = mkOption {
        type = types.str;
        default = "delete";
        description = ''
          What strategy to use when a backup fails
        '';
      };

      umask = mkOption {
        type = types.str;
        default = "0022";
        description = ''
          Umask of archives
        '';
      };

      client_can_delete = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Client can request to delete backups
        '';
      };

      client_can_force_backup = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Client can force a backup
        '';
      };

      client_can_list = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Client can query the server for a list of previous backups
        '';
      };

      client_can_restore = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Client can restore a backup
        '';
      };

      client_can_verify = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Client can request the verification of a backup
        '';
      };

      ca_conf = mkOption {
        type = types.str;
        default = "${libDir}/CA.cnf";
        description = ''
          Config file for CA generation
        '';
      };

      ca_name = mkOption {
        type = types.str;
        default = "burpCA";
        description = ''
          Name of CA
        '';
      };

      ca_server_name = mkOption {
        type = types.str;
        default = "burpserver";
        description = ''
          Common name in the certificate
        '';
      };

      ca_crl_check = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Check for revoked certificates
        '';
      };

      ca_burp_ca = mkOption {
        type = types.str;
        default = "${pkgs.burp}/bin/burp_ca";
        description = ''
          Location of burp binary used to generate client/server certificates
        '';
      };

      ca_csr_dir = mkOption {
        type = types.str;
        default = "${libDir}/CA-client";
        description = ''
          Location of client CA certificates
        '';
      };

      ssl_cert_ca = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert_ca.pem";
        description = ''
          Location of client SSL certificate authority -
          should refer to the same file on server and client
        '';
      };

      ssl_cert = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert-client.pem";
        description = ''
          Location of client SSL certificate
        '';
      };

      ssl_key = mkOption {
        type = types.str;
        default = "${libDir}/ssl_cert-client.key";
        description = ''
          Location of client SSL key
        '';
      };

      ssl_dhfile = mkOption {
        type = types.str;
        default = "${libDir}/dhfile.pem";
        description = ''
          Server DH file.
        '';
      };

      ssl_key_password = mkOption {
        type = types.str;
        default = "change-this-password";
        description = ''
          SSL key password, for loading a certificate with encryption.
        '';
      };

      ssl_peer_cn = mkOption {
        type = types.str;
        default = "burpserver";
        description = ''
          Common name in the certificate that the server gives the client
        '';
      };

      keeps = mkOption {
        type = types.listOf types.int;
        default = [ 7 ];
        description = ''
          How many backups to keep
        '';
      };

      timer_script = mkOption {
        type = types.str;
        default = "${pkgs.burp}/scripts/timer_script";
        description = ''
          Timer script used to evaluate if it's backup time
        '';
      };

      timer_args = mkOption {
        type = types.listOf types.str;
        default = [
          "20h"
          "Mon,Tue,Wed,Thu,Fri,00,01,02,03,04,05,19,20,21,22,23"
          "Sat,Sun,00,01,02,03,04,05,06,07,08,17,18,19,20,21,22,23"
        ];
        description = ''
          How often should backups be triggered
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for burp client. Contents will be added verbatim to the
          configuration file.
        '';
      };
    };
  };

  config = mkIf cfg.client.enable or cfg.server.enable {
    environment.systemPackages = [ pkgs.burp ];

    users.extraUsers.burp = {
      group = "burp";
      uid = config.ids.uids.burp;
      home = "${cfg.server.directory}";
      createHome = true;
      description = "BURP Server user";
      shell = "${pkgs.bash}/bin/bash";
    };

    users.extraGroups.burp.gid = config.ids.gids.burp;

    systemd.services.burp-server = mkIf cfg.server.enable {
      description = "BURP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.burp}/bin/burp -c ${burp_server_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };

    systemd.timers.burp = mkIf cfg.client.enable {
      description = "Timer for triggering BURP client and start a backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.client.frequency;
        Unit = "burp.service";
      };
    };

    systemd.services.burp = mkIf cfg.client.enable {
      description = "BURP client";
      after = [ "network.target" ];
      path = [ pkgs.burp pkgs.nettools pkgs.openssl ];

      preStart = ''
        if [ ! -d "${libDir}" ]; then
          mkdir -m 0755 -p ${libDir}
          mkdir -m 0700 -p ${cfg.client.ca_csr_dir}

          cp ${burp_conf} ${libDir}/burp.conf
          ${pkgs.burp}/bin/burp -c ${libDir}/burp.conf -g
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.burp}/bin/burp -c ${libDir}/burp.conf -a t";
      };
    };
  };
}
