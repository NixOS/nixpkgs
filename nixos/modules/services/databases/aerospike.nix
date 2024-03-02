{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.aerospike;

  aerospikeConf = pkgs.writeText "aerospike.conf" ''
    # This stanza must come first.
    service {
      user aerospike
      group aerospike
      paxos-single-replica-limit 1 # Number of nodes where the replica count is automatically reduced to 1.
      proto-fd-max 15000
      work-directory ${cfg.workDir}
    }
    logging {
      console {
        context any info
      }
    }
    mod-lua {
      system-path ${cfg.package}/share/udf/lua
      user-path ${cfg.workDir}/udf/lua
    }
    network {
      ${cfg.networkConfig}
    }
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.aerospike = {
      enable = mkEnableOption (lib.mdDoc "Aerospike server");

      package = mkPackageOption pkgs "aerospike" { };

      workDir = mkOption {
        type = types.str;
        default = "/var/lib/aerospike";
        description = lib.mdDoc "Location where Aerospike stores its files";
      };

      networkConfig = mkOption {
        type = types.lines;
        default = ''
          service {
            address any
            port 3000
          }

          heartbeat {
            address any
            mode mesh
            port 3002
            interval 150
            timeout 10
          }

          fabric {
            address any
            port 3001
          }

          info {
            address any
            port 3003
          }
        '';
        description = lib.mdDoc "network section of configuration file";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          namespace test {
            replication-factor 2
            memory-size 4G
            default-ttl 30d
            storage-engine memory
          }
        '';
        description = lib.mdDoc "Extra configuration";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.aerospike.enable {

    users.users.aerospike = {
      name = "aerospike";
      group = "aerospike";
      uid = config.ids.uids.aerospike;
      description = "Aerospike server user";
    };
    users.groups.aerospike.gid = config.ids.gids.aerospike;

    boot.kernel.sysctl = {
      "net.core.rmem_max" = mkDefault 15728640;
      "net.core.wmem_max" = mkDefault 5242880;
    };

    systemd.services.aerospike = rec {
      description = "Aerospike server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/asd --fgdaemon --config-file ${aerospikeConf}";
        User = "aerospike";
        Group = "aerospike";
        LimitNOFILE = 100000;
        PermissionsStartOnly = true;
      };

      preStart = ''
        if [ $(echo "$(${pkgs.procps}/bin/sysctl -n kernel.shmall) < 4294967296" | ${pkgs.bc}/bin/bc) == "1"  ]; then
          echo "kernel.shmall too low, setting to 4G pages"
          ${pkgs.procps}/bin/sysctl -w kernel.shmall=4294967296
        fi
        if [ $(echo "$(${pkgs.procps}/bin/sysctl -n kernel.shmmax) < 1073741824" | ${pkgs.bc}/bin/bc) == "1"  ]; then
          echo "kernel.shmmax too low, setting to 1GB"
          ${pkgs.procps}/bin/sysctl -w kernel.shmmax=1073741824
        fi
        install -d -m0700 -o ${serviceConfig.User} -g ${serviceConfig.Group} "${cfg.workDir}"
        install -d -m0700 -o ${serviceConfig.User} -g ${serviceConfig.Group} "${cfg.workDir}/smd"
        install -d -m0700 -o ${serviceConfig.User} -g ${serviceConfig.Group} "${cfg.workDir}/udf"
        install -d -m0700 -o ${serviceConfig.User} -g ${serviceConfig.Group} "${cfg.workDir}/udf/lua"
      '';
    };

  };

}
