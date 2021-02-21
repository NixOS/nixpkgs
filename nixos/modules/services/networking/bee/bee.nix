{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.bee;
  format = pkgs.formats.yaml {};
in {
  meta = {
    # doc = ./bee.xml;
    maintainers = with maintainers; [ attila-lendvai ];
  };

  ### interface

  options = {
    services.bee = {

      swarm = mkOption {
        type = types.nullOr (types.enum [ "mainnet" "testnet" ]);
        default = "testnet";
        description = ''
          Which swarm the bee node(s) should join. The value of this option will affect the default values of the following Bee settings: `chain-id`, `network-id`, `swap-endpoint`.
          If you want to configure these options by hand, then set `config.services.bee.swarm` to `null`.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.bee;
        defaultText = "pkgs.bee";
        example = "pkgs.bee-unstable";
        description = "The package providing the bee binary for the service.";
      };

      dataDir = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/bee";
        description = ''
          Data base directory for bee instances. Each instance will be under a subdirectory from [0..n]. Changing this from the default may break some auxiliary scripts.
        '';
      };

      instanceCount = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = "The number of clef instances to start up. Each bee node must have its own exclusive clef instance.";
      };

      apiPortBase = mkOption {
        type = types.nullOr types.int;
        default = 1600;
        description = ''
        '';
      };

      debugApiPortBase = mkOption {
        type = types.nullOr types.int;
        default = 1700;
        description = ''
        '';
      };

      p2pPortBase = mkOption {
        type = types.nullOr types.int;
        default = 1800;
        description = ''
        '';
      };

      settings = mkOption {
        type = format.type;
        description = ''
          Ethereum Swarm Bee configuration. Refer to
          <link xlink:href="https://gateway.ethswarm.org/bzz/docs.swarm.eth/docs/installation/configuration/"/>
          for details on supported values.
        '';
      };

      daemonNiceLevel = mkOption {
        type = with types; nullOr int;
        description = ''
          Daemon process priority for bee.
          0 is the default Unix process priority, 19 is the lowest.
        '';
      };

      daemonIOSchedulingClass = mkOption {
        type = with types; nullOr (either int str);
        default = null;
        example = "idle";
        description = ''
          IOSchedulingClass for the daemon process. Takes an integer between 0 and 3 or one of the strings `none`, `realtime`, `best-effort`, or `idle`.
        '';
      };

      daemonIOSchedulingPriority = mkOption {
        type = with types; nullOr (either int str);
        default = null;
        description = ''
          Takes an integer between 0 (highest priority) and 7 (lowest priority). The available priorities depend on the selected I/O scheduling class (see above).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "bee";
        description = ''
          User the bee binary should execute under.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "bee";
        description = ''
          Group the bee binary should execute under.
        '';
      };
    };
  };

  ### implementation

  config =
    let
      serviceEntries = genList makeSystemdServiceEntry cfg.instanceCount;
      beeConfigFiles = forEach serviceEntries head;

      deriveDataDir = id:
        "${cfg.dataDir}/${cfg.swarm or ""}/${toString id}/";

      makeSystemdTmpfilesEntry = id:
        [
          "d '${deriveDataDir id}' 0750 ${cfg.user} ${cfg.group}"
        ];

      makeSystemdServiceEntry = id:
        let
          dataDir        = deriveDataDir id;
          namePostfix    = if id == null then "" else "-${toString id}";
          serviceName    = "bee${namePostfix}";
          configFile     = format.generate "bee.yaml" settings;
          settings       = cfg.settings // {
            data-dir = dataDir;
            # TODO assert that these are not set by the user?
            # TODO ideally, this should call the relevant function in bee-clef.nix... but how?
            clef-signer-endpoint = "${config.services.bee-clef.dataDir}/${config.services.bee.swarm or ""}/${toString id}/clef.ipc";
            p2p-addr       = ":${toString (cfg.p2pPortBase + id)}";
            api-addr       = ":${toString (cfg.apiPortBase + id)}";
            debug-api-addr = ":${toString (cfg.debugApiPortBase + id)}";
          };
        in [ configFile {
          name = serviceName;
          value = {
            requires = optional (config.services.bee-clef.instanceCount != null &&
                                 0 < config.services.bee-clef.instanceCount)
              "bee-clef${namePostfix}.service";

            wants    = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            unitConfig = {
              Description = "Bee - Ethereum Swarm node";
              Documentation = "https://docs.ethswarm.org";
            };

            serviceConfig = {
              Nice = cfg.daemonNiceLevel;
              NoNewPrivileges = true;
              User = cfg.user;
              Group = cfg.group;
              ExecStart = "${cfg.package}/bin/bee --config=${configFile} start";
              Restart = "on-failure";
              RestartSec = 5;
              LimitNOFILE = 65535;   # Let's increase the ulimit, because LevelDB performs better with a large db-open-files-limit
            } // optionalAttrs (cfg.daemonIOSchedulingClass != null) {
              IOSchedulingClass = cfg.daemonIOSchedulingClass;
            } // optionalAttrs (cfg.daemonIOSchedulingPriority != null) {
              IOSchedulingPriority = cfg.daemonIOSchedulingPriority;
            };

            preStart = with settings; ''
              umask 0077
              if [ ! -f ${password-file} ]; then
                < /dev/urandom tr -dc _A-Z-a-z-0-9 2> /dev/null | head -c32 > ${password-file}
                echo "Initialized ${password-file} from /dev/urandom"
              fi
              if [ ! -f ${data-dir}/keys/libp2p.key ]; then
                ${cfg.package}/bin/bee init --config=${configFile} >/dev/null
                echo "
    Logs:   journalctl -f -u ${serviceName}

    Bee has SWAP enabled by default and it needs and Ethereum endpoint to operate.
    It is recommended to use an external signer with bee, e.g. go-ethereum's clef.
    Check the documentation for more information:
    - SWAP https://docs.ethswarm.org/docs/installation/manual#swap-bandwidth-incentives
    - External signer https://docs.ethswarm.org/docs/installation/bee-clef

    To get the node's Ethereum address check the logs, or run 'sudo bee-get-addr ${toString id}'."
              fi
            '';
          };
        }];
    in
      mkIf (0 < cfg.instanceCount) {
        assertions = [
          { assertion = cfg.instanceCount < 50;
            message = ''
              `services.bee.settings.instanceCount` is larger than 50. Are you sure?
            '';
          }
          { assertion = ! (hasAttr "password" cfg.settings);
            message = ''
              `services.bee.settings.password` is insecure. Use `services.bee.settings.password-file` or `systemd.services.bee.serviceConfig.EnvironmentFile` instead.
            '';
          }
          { assertion = (hasAttr "swap-endpoint" cfg.settings) || (cfg.settings.swap-enable or true == false);
            message = ''
              In a swap-enabled network a working Ethereum blockchain node is required. You must specify one using `services.bee.settings.swap-endpoint`. Disabling swap on the public network using `services.bee.settings.swap-enable = false` is not recommended, it's required for normal operation.
              You may either run your own <link xlink:href="https://www.xdaichain.com/">xDai</link> node when connecting to the Swarm `mainnet`, or <link xlink:href="https://goerli.net/">Görli</link> node when connecting to the `testnet`, or you may also subscribe to a service that gives you access to these blockchains. Please visit <link xlink:href="https://docs.ethswarm.org/docs/working-with-bee/configuration#swap-endpoint">the official Bee documentation</link> for more information.
            '';
          }
        ];

        warnings =
          optional (cfg.instanceCount > 1 && any (x: hasAttr x cfg.settings) ["data-dir" "clef-signer-endpoint" "p2p-addr" "api-addr" "debug-api-addr"])
            "You used `services.bee.instanceCount` to start multiple instances, but also specified one of the following bee config attributes that will be thus ignored: `api-addr` `data-dir` `debug-api-addr` `p2p-addr` `clef-signer-endpoint`.";

        services.bee.settings = rec {
          password-file        = lib.mkDefault "/var/lib/bee/password";
          clef-signer-enable   = lib.mkDefault true;
          mainnet              = lib.mkIf (cfg.swarm == "mainnet") true;
          network-id           = lib.mkIf (cfg.swarm != null) {
            testnet = 10;
            mainnet = 1;
          }.${cfg.swarm};
        };

        systemd.services = listToAttrs (forEach serviceEntries (x: elemAt x 1));

        environment.systemPackages =
          let
            bee-cli-tools = pkgs.stdenv.mkDerivation {
              name = "bee-cli-tools";
              buildInputs = with pkgs; [ coreutils gnugrep ];
              buildCommand = ''
                mkdir -p $out/bin/
                substituteAll ${./bee-get-addr} $out/bin/bee-get-addr
                chmod +x $out/bin/bee-get-addr
              '';
              inherit (pkgs.stdenv) shell;
              inherit (cfg) package dataDir;
              inherit beeConfigFiles;
            };
          in [ bee-cli-tools ];

        systemd.tmpfiles.rules =
          (concatLists (genList makeSystemdTmpfilesEntry cfg.instanceCount))
          ++
          [
            "d '${dirOf cfg.settings.password-file}' 0750 ${cfg.user} ${cfg.group}"
            "d '${cfg.dataDir}/'                     0750 ${cfg.user} ${cfg.group}"
            "d '${cfg.dataDir}/${cfg.swarm or ""}/'  0750 ${cfg.user} ${cfg.group}"
          ];

        users.users = optionalAttrs (cfg.user == "bee") {
          bee = {
            group = cfg.group;
            home = cfg.dataDir;
            isSystemUser = true;
            description = "Daemon user for Ethereum Swarm Bee";
            extraGroups = optional cfg.settings.clef-signer-enable or false
              # because we need to be able to read the clef.ipc file
              config.services.bee-clef.group;
          };
        };

        users.groups = optionalAttrs (cfg.group == "bee") {
          bee = {};
        };
      };
}
