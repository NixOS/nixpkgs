{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.autossh;

in

{

  ###### interface

  options = {

    services.autossh = {

      sessions = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                example = "socks-peer";
                description = "Name of the local AutoSSH session";
              };
              user = lib.mkOption {
                type = lib.types.str;
                example = "bill";
                description = "Name of the user the AutoSSH session should run as";
              };
              monitoringPort = lib.mkOption {
                type = lib.types.port;
                default = 0;
                example = 20000;
                description = ''
                  Port to be used by AutoSSH for peer monitoring. Note, that
                  AutoSSH also uses mport+1. Value of 0 disables the keep-alive
                  style monitoring
                '';
              };
              extraArguments = lib.mkOption {
                type = lib.types.separatedString " ";
                example = "-N -D4343 bill@socks.example.net";
                description = ''
                  Arguments to be passed to AutoSSH and retransmitted to SSH
                  process. Some meaningful options include -N (don't run remote
                  command), -D (open SOCKS proxy on local port), -R (forward
                  remote port), -L (forward local port), -v (Enable debug). Check
                  ssh manual for the complete list.
                '';
              };
            };
          }
        );

        default = [ ];
        description = ''
          List of AutoSSH sessions to start as systemd services. Each service is
          named 'autossh-{session.name}'.
        '';

        example = [
          {
            name = "socks-peer";
            user = "bill";
            monitoringPort = 20000;
            extraArguments = "-N -D4343 billremote@socks.host.net";
          }
        ];

      };
    };

  };

  ###### implementation

  config = lib.mkIf (cfg.sessions != [ ]) {

    systemd.services =

      lib.foldr (
        s: acc:
        acc
        // {
          "autossh-${s.name}" =
            let
              mport = if s ? monitoringPort then s.monitoringPort else 0;
            in
            {
              description = "AutoSSH session (" + s.name + ")";

              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];

              # To be able to start the service with no network connection
              environment.AUTOSSH_GATETIME = "0";

              # How often AutoSSH checks the network, in seconds
              environment.AUTOSSH_POLL = "30";

              serviceConfig = {
                User = "${s.user}";
                # AutoSSH may exit with 0 code if the SSH session was
                # gracefully terminated by either local or remote side.
                Restart = "on-success";
                ExecStart = "${pkgs.autossh}/bin/autossh -M ${toString mport} ${s.extraArguments}";
              };
            };
        }
      ) { } cfg.sessions;

    environment.systemPackages = [ pkgs.autossh ];

  };
}
