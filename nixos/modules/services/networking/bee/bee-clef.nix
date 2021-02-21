{ config, lib, pkgs, ... }:

# NOTE: for now nothing is installed into /etc/bee-clef/. The config
# files are used as read-only from the nix store, because they are
# not really variable. Open an issue if you need to change them.

with lib;
let
  cfg = config.services.bee-clef;

  deriveDataDir = id:
    "${cfg.dataDir}/${config.services.bee.swarm or ""}/${toString id}/";

  makeSystemdTmpfilesEntry = id:
    let
      dir = deriveDataDir id;
    in
      [
        "d '${dir}'          0750 ${cfg.user} ${cfg.group}"
        "d '${dir}/keystore' 0700 ${cfg.user} ${cfg.group}"
      ];

  makeSystemdServiceEntry = id:
    let
      dataDir        = deriveDataDir id;
      namePostfix    = if id == null then "" else "-${toString id}";
    in {
      name = "bee-clef${namePostfix}";
      value = {
        path = [
          # these are needed for the ensure-clef-account script
          pkgs.coreutils
          pkgs.gnused
          pkgs.gawk
        ];

        wants    = [ "network.target" ];
        wantedBy = [ "bee${namePostfix}.service" "multi-user.target" ];

        serviceConfig = {
          Nice = cfg.daemonNiceLevel;
          NoNewPrivileges = true;
          User = cfg.user;
          Group = cfg.group;
          ExecStartPre = ''${cfg.package}/share/bee-clef/ensure-clef-account'';
          ExecStart = "${cfg.package}/share/bee-clef/bee-clef-service start";
          ExecStop ="${cfg.package}/share/bee-clef/bee-clef-service stop";
          Environment = [
            # The size of clef's audit log is not trivial, so let's wait with
            # the introduction of more complexity until a real need shows up.
            #''"AUDIT_LOG_FILE=${cfg.auditLogDir}/clef-audit-log${namePostfix}.log"''
            ''"CONFIG_DIR=${cfg.package}/share/bee-clef/"''
            ''"DATA_DIR=${dataDir}"''
            ''"PASSWORD_FILE=${cfg.passwordFile}"''
            ''"BEE_CLEF_CHAIN_ID=${toString cfg.chainId}"''
          ];
          Restart = "on-failure";
          RestartSec = 5;
        } // optionalAttrs (cfg.daemonIOSchedulingClass != null) {
          IOSchedulingClass = cfg.daemonIOSchedulingClass;
        } // optionalAttrs (cfg.daemonIOSchedulingPriority != null) {
          IOSchedulingPriority = cfg.daemonIOSchedulingPriority;
        };
      };
    };

in {
  meta = {
    maintainers = with maintainers; [ attila-lendvai ];
  };

  ### interface

  options = {
    services.bee-clef = {
      package = mkOption {
        type = types.package;
        default = pkgs.bee-clef;
        defaultText = "pkgs.bee-clef";
        example = "pkgs.bee-clef-unstable";
        description = "The package providing the bee-clef files for the service.";
      };

      dataDir = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/bee-clef";
        description = ''
          Base directory for bee-clef instances. Each instance will be under a subdirectory named `[0..n]`.
        '';
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/bee-clef/password";
        description = ''
          Password file shared by each bee-clef instance. Will be generated from `/dev/urandom` when missing.
        '';
      };

      chainId = mkOption {
        type = types.nullOr types.int;
        default = {
          testnet = 5;   # Ethereum Goerli testnet
          mainnet = 100; # xDai chain
        }.${config.services.bee.swarm or "testnet"};
        description = ''
          The value of the `--chainid` argument of the `clef` binary; i.e. which blockchain `clef` should connect to.
          Certain elements in the Bee's configuration must match that of Clef's. Unless you know what you're doing, you should rather set the `config.services.bee.settings.swarm` variable instead, that will affect the default of this option, too.
        '';
      };

      instanceCount = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        # NOTE: this could work, and is simpler, except it breaks the building of the manual
        # default = if config.services.bee.settings.clef-signer-enable or false
        #           then config.services.bee.instanceCount
        #           else 0;
        description = ''
          The number of clef instances to start up. Each Bee node must have its own exclusive clef instance.
          When `config.services.bee.settings.clef-signer-enable` is true, then it defaults to `config.services.bee.instanceCount`.
        '';
      };

      daemonNiceLevel = mkOption {
        type = with types; nullOr int;
        description = ''
          Daemon process priority for bee-clef.
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
        default = "bee-clef";
        description = ''
          User the bee-clef daemon should execute under.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "bee-clef";
        description = ''
          Group the bee-clef daemon should execute under.
        '';
      };
    };
  };

  ### implementation

  config = let
    instanceCount = if cfg.instanceCount == null
                    then
                      (if config.services.bee.settings.clef-signer-enable or false
                       then config.services.bee.instanceCount or 0
                       else 0)
                    else cfg.instanceCount;
  in
    mkIf (0 < instanceCount) {
      # if we ever want to have rules.js under /etc/bee-clef/
      # environment.etc."bee-clef/rules.js".source = ${cfg.package}/rules.js

      environment.systemPackages =
        let
          bee-clef-cli-tools = pkgs.stdenv.mkDerivation {
            name = "bee-clef-cli-tools";
            buildInputs = with pkgs; [ coreutils ];
            buildCommand = ''
              mkdir -p $out/bin/
              substituteAll ${./bee-clef-keys} $out/bin/bee-clef-keys
              chmod +x $out/bin/bee-clef-keys
            '';
            inherit (pkgs.stdenv) shell;
            inherit (cfg) dataDir;
            inherit (config.services.bee) swarm;
          };
        in [ bee-clef-cli-tools ];

      systemd.tmpfiles.rules =
        (concatLists (genList makeSystemdTmpfilesEntry instanceCount))
        ++
        [
          "d '${cfg.dataDir}/' 0750 ${cfg.user} ${cfg.group}"
          "d '${cfg.dataDir}/${config.services.bee.swarm or ""}/' 0750 ${cfg.user} ${cfg.group}"
        ];

      systemd.services = listToAttrs (genList makeSystemdServiceEntry instanceCount);

      users.users = optionalAttrs (cfg.user == "bee-clef") {
        bee-clef = {
          group = cfg.group;
          home = cfg.dataDir;
          isSystemUser = true;
          description = "Daemon user for the bee-clef service";
        };
      };

      users.groups = optionalAttrs (cfg.group == "bee-clef") {
        bee-clef = {};
      };
    };
}
