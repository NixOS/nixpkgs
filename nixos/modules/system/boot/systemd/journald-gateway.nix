{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.journald.gateway;

  cliArgs = lib.cli.toGNUCommandLineShell { } {
    # If either of these are null / false, they are not passed in the command-line
    inherit (cfg)
      cert
      key
      trust
      system
      user
      merge
      ;
  };
in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  options.services.journald.gateway = {
    enable = lib.mkEnableOption "the HTTP gateway to the journal";

    port = lib.mkOption {
      default = 19531;
      type = lib.types.port;
      description = ''
        The port to listen to.
      '';
    };

    cert = lib.mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
        The path to a file or `AF_UNIX` stream socket to read the server
        certificate from.

        The certificate must be in PEM format. This option switches
        `systemd-journal-gatewayd` into HTTPS mode and must be used together
        with {option}`services.journald.gateway.key`.
      '';
    };

    key = lib.mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
        Specify the path to a file or `AF_UNIX` stream socket to read the
        secret server key corresponding to the certificate specified with
        {option}`services.journald.gateway.cert` from.

        The key must be in PEM format.

        This key should not be world-readable, and must be readably by the
        `systemd-journal-gateway` user.
      '';
    };

    trust = lib.mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
        Specify the path to a file or `AF_UNIX` stream socket to read a CA
        certificate from.

        The certificate must be in PEM format.

        Setting this option enforces client certificate checking.
      '';
    };

    system = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Serve entries from system services and the kernel.

        This has the same meaning as `--system` for {manpage}`journalctl(1)`.
      '';
    };

    user = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Serve entries from services for the current user.

        This has the same meaning as `--user` for {manpage}`journalctl(1)`.
      '';
    };

    merge = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Serve entries interleaved from all available journals, including other
        machines.

        This has the same meaning as `--merge` option for
        {manpage}`journalctl(1)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # This prevents the weird case were disabling "system" and "user"
        # actually enables both because the cli flags are not present.
        assertion = cfg.system || cfg.user;
        message = ''
          systemd-journal-gatewayd cannot serve neither "system" nor "user"
          journals.
        '';
      }
    ];

    systemd.additionalUpstreamSystemUnits = [
      "systemd-journal-gatewayd.socket"
      "systemd-journal-gatewayd.service"
    ];

    users.users.systemd-journal-gateway.uid = config.ids.uids.systemd-journal-gateway;
    users.users.systemd-journal-gateway.group = "systemd-journal-gateway";
    users.groups.systemd-journal-gateway.gid = config.ids.gids.systemd-journal-gateway;

    systemd.services.systemd-journal-gatewayd.serviceConfig.ExecStart = [
      # Clear the default command line
      ""
      "${pkgs.systemd}/lib/systemd/systemd-journal-gatewayd ${cliArgs}"
    ];

    systemd.sockets.systemd-journal-gatewayd = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        # Clear the default port
        ""
        (toString cfg.port)
      ];
    };
  };
}
