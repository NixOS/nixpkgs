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
                type = lib.types.int;
                default = 0;
                example = 20000;
                description = ''
                  Port to be used by AutoSSH for peer monitoring. Note, that
                  AutoSSH also uses mport+1. Value of 0 disables the keep-alive
                  style monitoring
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

          # To be able to start the service with no network connection
          environment.AUTOSSH_GATETIME = "0";

          # How often AutoSSH checks the network, in seconds
          environment.AUTOSSH_POLL = "30";

          serviceConfig = {
            User = "${value.user}";
            # AutoSSH may exit with 0 code if the SSH session was
            # gracefully terminated by either local or remote side.
            Restart = "on-success";
            ExecStart = "${pkgs.autossh}/bin/autossh -M ${toString value.monitoringPort} ${lib.strings.concatStringsSep " " value.sshArgs} ${value.destination}";
          };
        })
      ) cfg.sessions;

    environment.systemPackages = [ pkgs.autossh ];

  };
}
