{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.shellinabox;

  # If a certificate file is specified, shellinaboxd requires
  # a file descriptor to retrieve it
  fd = "3";
  createFd = optionalString (cfg.certFile != null) "${fd}<${cfg.certFile}";

  # Command line arguments for the shellinabox daemon
  args = [ "--background" ]
   ++ optional (! cfg.enableSSL) "--disable-ssl"
   ++ optional (cfg.certFile != null) "--cert-fd=${fd}"
   ++ optional (cfg.certDirectory != null) "--cert=${cfg.certDirectory}"
   ++ cfg.extraOptions;

  # Command to start shellinaboxd
  cmd = "${pkgs.shellinabox}/bin/shellinaboxd ${concatStringsSep " " args}";

  # Command to start shellinaboxd if certFile is specified
  wrappedCmd = "${pkgs.bash}/bin/bash -c 'exec ${createFd} && ${cmd}'";

in

{

  ###### interface

  options = {
    services.shellinabox = {
      enable = mkEnableOption "shellinabox daemon";

      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          User to run shellinaboxd as. If started as root, the server drops
          privileges by changing to nobody, unless overridden by the
          <literal>--user</literal> option.
        '';
      };

      enableSSL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable SSL (https) support.
        '';
      };

      certDirectory = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/certs";
        description = ''
          The daemon will look in this directory far any certificates.
          If the browser negotiated a Server Name Identification the daemon
          will look for a matching certificate-SERVERNAME.pem file. If no SNI
          handshake takes place, it will fall back on using the certificate in the
          certificate.pem file.

          If no suitable certificate is installed, shellinaboxd will attempt to
          create a new self-signed certificate. This will only succeed if, after
          dropping privileges, shellinaboxd has write permissions for this
          directory.
        '';
      };

      certFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/certificate.pem";
        description = "Path to server SSL certificate.";
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--port=443" "--service /:LOGIN" ];
        description = ''
          A list of strings to be appended to the command line arguments
          for shellinaboxd. Please see the manual page
          <link xlink:href="https://code.google.com/p/shellinabox/wiki/shellinaboxd_man"/>
          for a full list of available arguments.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions =
      [ { assertion = cfg.enableSSL == true
            -> cfg.certDirectory != null || cfg.certFile != null;
          message = "SSL is enabled for shellinabox, but no certDirectory or certFile has been specefied."; }
        { assertion = ! (cfg.certDirectory != null && cfg.certFile != null);
          message = "Cannot set both certDirectory and certFile for shellinabox."; }
      ];

    systemd.services.shellinaboxd = {
      description = "Shellinabox Web Server Daemon";

      wantedBy = [ "multi-user.target" ];
      requires = [ "sshd.service" ];
      after = [ "sshd.service" ];

      serviceConfig = {
        Type = "forking";
        User = "${cfg.user}";
        ExecStart = "${if cfg.certFile == null then "${cmd}" else "${wrappedCmd}"}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
