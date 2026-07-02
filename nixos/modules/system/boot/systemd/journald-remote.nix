{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.journald.remote;
  format = pkgs.formats.systemd { };

  cliArgs = lib.cli.toCommandLineShellGNU { } {
    inherit (cfg) output;
    # "-3" specifies the file descriptor from the .socket unit.
    "listen-http" = "-3";
  };

  tlsOptionRemovedMessage = ''
    systemd in Nixpkgs is built without GnuTLS, so systemd-journal-remote
    cannot accept HTTPS connections or validate client certificates. Use a
    reverse proxy (such as nginx) to terminate TLS in front of journal-remote
    if you need encrypted ingestion.
  '';
in
{
  meta.maintainers = [ ];
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "journald"
      "remote"
      "listen"
    ] tlsOptionRemovedMessage)
  ];

  options.services.journald.remote = {
    enable = lib.mkEnableOption "receiving systemd journals from the network";

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
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      map
        (key: {
          assertion = !(cfg.settings ? Remote.${key});
          message = ''
            The option definition `services.journald.remote.settings.Remote.${key}'
            no longer has any effect; please remove it.
            ${tlsOptionRemovedMessage}
          '';
        })
        [
          "ServerKeyFile"
          "ServerCertificateFile"
          "TrustedCertificateFile"
        ];

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
