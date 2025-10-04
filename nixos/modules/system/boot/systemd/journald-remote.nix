{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.journald.remote;
  format = pkgs.formats.systemd { };

  cliArgs = lib.cli.toGNUCommandLineShell { } {
    inherit (cfg) output;
    # "-3" specifies the file descriptor from the .socket unit.
    "listen-${cfg.listen}" = "-3";
  };
in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  options.services.journald.remote = {
    enable = lib.mkEnableOption "receiving systemd journals from the network";

    listen = lib.mkOption {
      default = "https";
      type = lib.types.enum [
        "https"
        "http"
      ];
      description = ''
        Which protocol to listen to.
      '';
    };

    output = lib.mkOption {
      default = "/var/log/journal/remote/";
      type = lib.types.str;
      description = ''
        The location of the output journal.

        In case the output file is not specified, journal files will be created
        underneath the selected directory. Files will be called
        {file}`remote-hostname.journal`, where the `hostname` part is the
        escaped hostname of the source endpoint of the connection, or the
        numerical address if the hostname cannot be determined.
      '';
    };

    port = lib.mkOption {
      default = 19532;
      type = lib.types.port;
      description = ''
        The port to listen to.

        Note that this option is used only if
        {option}`services.journald.upload.listen` is configured to be either
        "https" or "http".
      '';
    };

    settings = lib.mkOption {
      default = { };

      description = ''
        Configuration in the journal-remote configuration file. See
        {manpage}`journal-remote.conf(5)` for available options.
      '';

      type = lib.types.submodule {
        freeformType = format.type;

        options.Remote = {
          Seal = lib.mkOption {
            default = false;
            example = true;
            type = lib.types.bool;
            description = ''
              Periodically sign the data in the journal using Forward Secure
              Sealing.
            '';
          };

          SplitMode = lib.mkOption {
            default = "host";
            example = "none";
            type = lib.types.enum [
              "host"
              "none"
            ];
            description = ''
              With "host", a separate output file is used, based on the
              hostname of the other endpoint of a connection. With "none", only
              one output journal file is used.
            '';
          };

          ServerKeyFile = lib.mkOption {
            default = "/etc/ssl/private/journal-remote.pem";
            type = lib.types.str;
            description = ''
              A path to a SSL secret key file in PEM format.

              Note that due to security reasons, `systemd-journal-remote` will
              refuse files from the world-readable `/nix/store`. This file
              should be readable by the "" user.

              This option can be used with `listen = "https"`. If the path
              refers to an `AF_UNIX` stream socket in the file system a
              connection is made to it and the key read from it.
            '';
          };

          ServerCertificateFile = lib.mkOption {
            default = "/etc/ssl/certs/journal-remote.pem";
            type = lib.types.str;
            description = ''
              A path to a SSL certificate file in PEM format.

              This option can be used with `listen = "https"`. If the path
              refers to an `AF_UNIX` stream socket in the file system a
              connection is made to it and the certificate read from it.
            '';
          };

          TrustedCertificateFile = lib.mkOption {
            default = "/etc/ssl/ca/trusted.pem";
            type = lib.types.str;
            description = ''
              A path to a SSL CA certificate file in PEM format, or `all`.

              If `all` is set, then client certificate checking will be
              disabled.

              This option can be used with `listen = "https"`. If the path
              refers to an `AF_UNIX` stream socket in the file system a
              connection is made to it and the certificate read from it.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-journal-remote.service"
      "systemd-journal-remote.socket"
    ];

    systemd.services.systemd-journal-remote.serviceConfig.ExecStart = [
      # Clear the default command line
      ""
      "${pkgs.systemd}/lib/systemd/systemd-journal-remote ${cliArgs}"
    ];

    systemd.sockets.systemd-journal-remote = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        # Clear the default port
        ""
        (toString cfg.port)
      ];
    };

    # User and group used by systemd-journal-remote.service
    users.groups.systemd-journal-remote = { };
    users.users.systemd-journal-remote = {
      isSystemUser = true;
      group = "systemd-journal-remote";
    };

    environment.etc."systemd/journal-remote.conf".source =
      format.generate "journal-remote.conf" cfg.settings;
  };
}
