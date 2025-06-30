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
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              user = lib.mkOption {
                type = lib.types.str;
                example = "bill";
                description = "Name of the user the AutoSSH session should run as";
              };
              monitoringPort = lib.mkOption {
                type = lib.types.oneOf [
                  lib.types.int
                  lib.types.str
                ];
                default = 0;
                example = 20000;
                description = ''
                  Port to be used by AutoSSH for peer monitoring. Can be an integer,
                  in which case AutoSSH also uses mport+1. If it is a string, should
                  be in the format of port:port to use both instead of mport+1.
                  A value of 0 disables the keep-alive style monitoring.
                '';
              };
              sshArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                example = [
                  "-N"
                  "-D4343"
                ];
                description = ''
                  Arguments to be passed to the SSH session, see `man ssh` for possible options.
                '';
              };
              destination = lib.mkOption {
                type = lib.types.str;
                example = "bill@socks.example.net";
                description = ''
                  The user and host you want AutoSSH to connect to.
                '';
              };
            };
          }
        );

        default = { };
        description = ''
          List of AutoSSH sessions to start as systemd services. Each service is
          named 'autossh-{name}'.
        '';

        example = {
          socks-peer = {
            user = "bill";
            monitoringPort = 20000;
            sshArgs = [
              "-N"
              "-D4343"
            ];
            destination = "bill@socks.example.net";
          };
        };

      };
    };

  };

  ###### implementation

  config = lib.mkIf (cfg.sessions != [ ]) {

    systemd.services =

      lib.attrsets.mapAttrs' (
        name: value:
        lib.attrsets.nameValuePair ("autossh-${name}") ({
          description = "AutoSSH session (" + name + ")";

          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            # To be able to start the service with no network connection
            AUTOSSH_GATETIME = "0";

            # How often AutoSSH checks the network, in seconds
            AUTOSSH_POLL = "30";

            # We use the variable instead of the flag to allow `ssh -M` "master mode" to be used
            AUTOSSH_PORT = toString value.monitoringPort;
          };

          serviceConfig = {
            User = "${value.user}";
            # AutoSSH may exit with 0 code if the SSH session was
            # gracefully terminated by either local or remote side.
            Restart = "on-success";
            ExecStart = "${pkgs.autossh}/bin/autossh ${lib.strings.concatStringsSep " " value.sshArgs} ${value.destination}";
          };
        })
      ) cfg.sessions;
  };
}
