{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.autossh-ng;

in

{

  ###### interface

  options = {

    services.autossh-ng = {

      sessions = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, config, ... }:
            {
              options = {
                user = lib.mkOption {
                  type = lib.types.str;
                  example = "bill";
                  description = "Name of the user the local session should run as";
                };
                destination = lib.mkOption {
                  type = lib.types.str;
                  example = "billremote@socks.host.net";
                  description = "Destination to connect to";
                };
                hostKeyChecking = lib.mkOption {
                  type = lib.types.bool;
                  description = ''
                    Whether to enable host key checking. The advantage of enabling
                    host key checking is that it protects against AitM attacks, on
                    the other hand disabling host key checking makes the autossh
                    connection resilient against host key rotations of the destination
                    machine.
                  '';
                };
                knownHostsFile = lib.mkOption {
                  type = lib.types.path;
                  example = "/home/bill/.ssh/known_hosts";
                  description = ''
                    If you enabled host key checking, use this file to verify
                    destination host keys against.
                  '';
                };
                extraArguments = lib.mkOption {
                  type = lib.types.separatedString " ";
                  example = "-L2222:localhost:22 -i \${config.age.secrets.privatekey.path}";
                  description = ''
                    Arguments to be passed to the ssh process process.
                    Some meaningful options include
                    -D (open SOCKS proxy on local port),
                    -R (forward remote port),
                    -L (forward local port),
                    -v (Enable debug),
                    -i (identity file to use).
                    Check ssh manual for the complete list.
                  '';
                };
              };
            }
          )
        );

        default = { };
        description = ''
          Set of SSH sessions to start as systemd services. Each service is
          named 'autossh-ng-{session.name}'.
        '';

        example = {
          "socket-peer" = {
            user = "bill";
            destination = "billremote@socks.host.net";
            extraArguments = "-L2222:localhost:22 -i \${config.age.secrets.privatekey.path}";
          };
        };

      };
    };

  };

  ###### implementation

  config = lib.mkIf (cfg.sessions != { }) {

    systemd.services =

      lib.attrsets.mapAttrs' (name: s: {
        name = "autossh-ng-${name}";
        value = {
          description = "Automatic SSH session (" + name + ")";

          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "notify";
            NotifyAccess = "all";
            User = "${s.user}";
            # backoff would be nice, but doesn't automatically
            # get reset on successful start yet, so static 10s restart for now:
            Restart = "always";
            RestartSec = "10s";
            ExecStart =
              let
                hostKeyCheckOption =
                  if s.hostKeyChecking then
                    "-o \"UserKnownHostsFile=${s.knownHostsFile}\""
                  else
                    "-o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\"";
                ready = pkgs.writers.writeBash "systemd-signal-ready" ''
                  ${pkgs.systemd}/bin/systemd-notify --ready
                '';
              in
              ''
                ${pkgs.openssh}/bin/ssh \
                  -o "ServerAliveInterval 30" \
                  -o "ServerAliveCountMax 3" \
                  -o "PermitLocalCommand=yes" \
                  -o "LocalCommand ${ready}" \
                  -o ExitOnForwardFailure=yes \
                  ${hostKeyCheckOption} \
                  -N \
                  ${s.extraArguments} \
                  ${s.destination}
              '';
          };
        };
      }) cfg.sessions;
  };
}
