{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.uptimed;
  stateDir = "/var/lib/uptimed";
  runtimeDir = "/run/uptimed";
in
{
  options = {
    services.uptimed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable `uptimed`, allowing you to track
          your highest uptimes.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf (either str (listOf str));
          options = {
            PIDFILE = lib.mkOption {
              type = lib.types.path;
              default = "${runtimeDir}/pid";
              description = "Where to put uptimed's PID file";
            };

            SEND_EMAIL = lib.mkOption {
              type = lib.types.enum [
                "0"
                "1"
                "2"
                "3"
              ];
              default = "0";
              description = ''
                Whether to send email. This assumes that you have a working MTA on your system.

                - `0`: off
                - `1`: on
                - `2`: only for milestones
                - `3`: only for records
              '';
            };

            SENDMAIL = lib.mkOption {
              type = lib.types.path;
              default = "${pkgs.system-sendmail}/bin/sendmail -t";
              defaultText = lib.literalExpression ''"''${pkgs.system-sendmail}/bin/sendmail -t"'';
              description = ''
                The command to use for sending mail.

                The command needs to be {command}`sendmail` compatible.
              '';
            };

            EMAIL = lib.mkOption {
              type = lib.types.str;
              description = "Which email to send";
              example = "someone@example.com";
              default = "root@localhost";
            };
          };
        };
        default = { };
        description = ''
          Settings for {file}`uptimed.conf`.

          For available options, see <https://github.com/rpodgorny/uptimed/blob/master/etc/uptimed.conf-dist>.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.uptimed ];

    systemd.services.uptimed = {
      unitConfig.Documentation = "man:uptimed(8) man:uprecords(1)";
      description = "uptimed service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        Restart = "on-failure";
        User = "uptimed";
        DynamicUser = true;
        Nice = 19;
        IOSchedulingClass = "idle";
        PrivateTmp = "yes";
        PrivateNetwork = "yes";
        NoNewPrivileges = "yes";
        StateDirectory = [ "uptimed" ];
        RuntimeDirectory = [ "uptimed" ];
        InaccessibleDirectories = "/home";
        ExecStart = "${pkgs.uptimed}/sbin/uptimed -f";

        BindReadOnlyPaths =
          let
            configFile = lib.pipe cfg.settings [
              (lib.mapAttrsToList (
                k: v: if builtins.isList v then lib.mapConcatStringsSep "\n" (v': "${k}=${v'}") v else "${k}=${v}"
              ))
              (lib.concatStringsSep "\n")
              (pkgs.writeText "uptimed.conf")
            ];
          in
          [
            "${configFile}:/etc/uptimed/uptimed.conf"
          ];
      };

      preStart = ''
        if ! test -f ${stateDir}/bootid ; then
          ${pkgs.uptimed}/sbin/uptimed -b
        fi
      '';
    };
  };
}
