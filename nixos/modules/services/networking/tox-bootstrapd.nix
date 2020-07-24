{ config, lib, pkgs, ... }:

with lib;

let
  home = "/var/lib/tox-bootstrapd";
  PIDFile = "${home}/pid";

  pkg = pkgs.libtoxcore;
  cfg = config.services.toxBootstrapd;
  cfgFile = builtins.toFile "tox-bootstrapd.conf"
    ''
      port = ${toString cfg.port}
      keys_file_path = "${home}/keys"
      pid_file_path = "${PIDFile}"
      ${cfg.extraConfig}
    '';
in
{
  options =
    { services.toxBootstrapd =
        { enable = mkOption {
            type = types.bool;
            default = false;
            description =
              ''
                Whether to enable the Tox DHT bootstrap daemon.
              '';
          };

          port = mkOption {
            type = types.int;
            default = 33445;
            description = "Listening port (UDP).";
          };

          keysFile = mkOption {
            type = types.str;
            default = "${home}/keys";
            description = "Node key file.";
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description =
              ''
                Configuration for bootstrap daemon.
                See <link xlink:href="https://github.com/irungentoo/toxcore/blob/master/other/bootstrap_daemon/tox-bootstrapd.conf"/>
                and <link xlink:href="http://wiki.tox.im/Nodes"/>.
             '';
          };
      };

    };

  config = mkIf config.services.toxBootstrapd.enable {

    users.users.tox-bootstrapd =
      { uid = config.ids.uids.tox-bootstrapd;
        description = "Tox bootstrap daemon user";
        inherit home;
        createHome = true;
      };

    systemd.services.tox-bootstrapd = {
      description = "Tox DHT bootstrap daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        { ExecStart = "${pkg}/bin/tox-bootstrapd --config=${cfgFile}";
          Type = "forking";
          inherit PIDFile;
          User = "tox-bootstrapd";
        };
    };

  };
}
