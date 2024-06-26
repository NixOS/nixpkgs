{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.clamsmtp;
  clamdSocket = "/run/clamav/clamd.ctl"; # See services/security/clamav.nix
in
{
  ##### interface
  options = {
    services.clamsmtp = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable clamsmtp.";
      };

      instances = mkOption {
        description = "Instances of clamsmtp to run.";
        type = types.listOf (
          types.submodule {
            options = {
              action = mkOption {
                type = types.enum [
                  "bounce"
                  "drop"
                  "pass"
                ];
                default = "drop";
                description = ''
                  Action to take when a virus is detected.

                  Note that viruses often spoof sender addresses, so bouncing is
                  in most cases not a good idea.
                '';
              };

              header = mkOption {
                type = types.str;
                default = "";
                example = "X-Virus-Scanned: ClamAV using ClamSMTP";
                description = ''
                  A header to add to scanned messages. See clamsmtpd.conf(5) for
                  more details. Empty means no header.
                '';
              };

              keepAlives = mkOption {
                type = types.int;
                default = 0;
                description = ''
                  Number of seconds to wait between each NOOP sent to the sending
                  server. 0 to disable.

                  This is meant for slow servers where the sending MTA times out
                  waiting for clamd to scan the file.
                '';
              };

              listen = mkOption {
                type = types.str;
                example = "127.0.0.1:10025";
                description = ''
                  Address to wait for incoming SMTP connections on. See
                  clamsmtpd.conf(5) for more details.
                '';
              };

              quarantine = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to quarantine files that contain viruses by leaving them
                  in the temporary directory.
                '';
              };

              maxConnections = mkOption {
                type = types.int;
                default = 64;
                description = "Maximum number of connections to accept at once.";
              };

              outAddress = mkOption {
                type = types.str;
                description = ''
                  Address of the SMTP server to send email to once it has been
                  scanned.
                '';
              };

              tempDirectory = mkOption {
                type = types.str;
                default = "/tmp";
                description = ''
                  Temporary directory that needs to be accessible to both clamd
                  and clamsmtpd.
                '';
              };

              timeout = mkOption {
                type = types.int;
                default = 180;
                description = "Time-out for network connections.";
              };

              transparentProxy = mkOption {
                type = types.bool;
                default = false;
                description = "Enable clamsmtp's transparent proxy support.";
              };

              virusAction = mkOption {
                type = with types; nullOr path;
                default = null;
                description = ''
                  Command to run when a virus is found. Please see VIRUS ACTION in
                  clamsmtpd(8) for a discussion of this option and its safe use.
                '';
              };

              xClient = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Send the XCLIENT command to the receiving server, for forwarding
                  client addresses and connection information if the receiving
                  server supports this feature.
                '';
              };
            };
          }
        );
      };
    };
  };

  ##### implementation
  config =
    let
      configfile =
        conf:
        pkgs.writeText "clamsmtpd.conf" ''
          Action: ${conf.action}
          ClamAddress: ${clamdSocket}
          Header: ${conf.header}
          KeepAlives: ${toString conf.keepAlives}
          Listen: ${conf.listen}
          Quarantine: ${if conf.quarantine then "on" else "off"}
          MaxConnections: ${toString conf.maxConnections}
          OutAddress: ${conf.outAddress}
          TempDirectory: ${conf.tempDirectory}
          TimeOut: ${toString conf.timeout}
          TransparentProxy: ${if conf.transparentProxy then "on" else "off"}
          User: clamav
          ${optionalString (conf.virusAction != null) "VirusAction: ${conf.virusAction}"}
          XClient: ${if conf.xClient then "on" else "off"}
        '';
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = config.services.clamav.daemon.enable;
          message = "clamsmtp requires clamav to be enabled";
        }
      ];

      systemd.services = listToAttrs (
        imap1 (
          i: conf:
          nameValuePair "clamsmtp-${toString i}" {
            description = "ClamSMTP instance ${toString i}";
            wantedBy = [ "multi-user.target" ];
            script = "exec ${pkgs.clamsmtp}/bin/clamsmtpd -f ${configfile conf}";
            after = [ "clamav-daemon.service" ];
            requires = [ "clamav-daemon.service" ];
            serviceConfig.Type = "forking";
            serviceConfig.PrivateTmp = "yes";
            unitConfig.JoinsNamespaceOf = "clamav-daemon.service";
          }
        ) cfg.instances
      );
    };

  meta.maintainers = with lib.maintainers; [ ekleog ];
}
