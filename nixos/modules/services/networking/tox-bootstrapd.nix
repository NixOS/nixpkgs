{ config, lib, pkgs, ... }:

with lib;

let
  WorkingDirectory = "/var/lib/tox-bootstrapd";
  PIDFile = "${WorkingDirectory}/pid";

  pkg = pkgs.libtoxcore;
  cfg = config.services.toxBootstrapd;
  cfgFile = builtins.toFile "tox-bootstrapd.conf"
    ''
      port = ${toString cfg.port}
      keys_file_path = "${WorkingDirectory}/keys"
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
              lib.mdDoc ''
                Whether to enable the Tox DHT bootstrap daemon.
              '';
          };

          port = mkOption {
            type = types.port;
            default = 33445;
            description = lib.mdDoc "Listening port (UDP).";
          };

          keysFile = mkOption {
            type = types.str;
            default = "${WorkingDirectory}/keys";
            description = lib.mdDoc "Node key file.";
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description =
              lib.mdDoc ''
                Configuration for bootstrap daemon.
                See <https://github.com/irungentoo/toxcore/blob/master/other/bootstrap_daemon/tox-bootstrapd.conf>
                and <http://wiki.tox.im/Nodes>.
             '';
          };
      };

    };

  config = mkIf config.services.toxBootstrapd.enable {

    systemd.services.tox-bootstrapd = {
      description = "Tox DHT bootstrap daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        { ExecStart = "${pkg}/bin/tox-bootstrapd --config=${cfgFile}";
          Type = "forking";
          inherit PIDFile WorkingDirectory;
          AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
          DynamicUser = true;
          StateDirectory = "tox-bootstrapd";
        };
    };

  };
}
