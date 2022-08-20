{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.bee;
  format = pkgs.formats.yaml {};
  configFile = format.generate "bee.yaml" cfg.settings;
in {
  meta = {
    # doc = ./bee.xml;
    maintainers = with maintainers; [ attila-lendvai ];
  };

  ### interface

  options = {
    services.bee = {
      enable = mkEnableOption "Ethereum Swarm Bee";

      package = mkOption {
        type = types.package;
        default = pkgs.bee;
        defaultText = literalExpression "pkgs.bee";
        example = literalExpression "pkgs.bee-unstable";
        description = lib.mdDoc "The package providing the bee binary for the service.";
      };

      settings = mkOption {
        type = format.type;
        description = lib.mdDoc ''
          Ethereum Swarm Bee configuration. Refer to
          <https://gateway.ethswarm.org/bzz/docs.swarm.eth/docs/installation/configuration/>
          for details on supported values.
        '';
      };

      daemonNiceLevel = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Daemon process priority for bee.
          0 is the default Unix process priority, 19 is the lowest.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "bee";
        description = lib.mdDoc ''
          User the bee binary should execute under.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "bee";
        description = lib.mdDoc ''
          Group the bee binary should execute under.
        '';
      };
    };
  };

  ### implementation

  config = mkIf cfg.enable {
    assertions = [
      { assertion = (hasAttr "password" cfg.settings) != true;
        message = ''
          `services.bee.settings.password` is insecure. Use `services.bee.settings.password-file` or `systemd.services.bee.serviceConfig.EnvironmentFile` instead.
        '';
      }
      { assertion = (hasAttr "swap-endpoint" cfg.settings) || (cfg.settings.swap-enable or true == false);
        message = ''
          In a swap-enabled network a working Ethereum blockchain node is required. You must specify one using `services.bee.settings.swap-endpoint`, or disable `services.bee.settings.swap-enable` = false.
        '';
      }
    ];

    warnings = optional (! config.services.bee-clef.enable) "The bee service requires an external signer. Consider setting `config.services.bee-clef.enable` = true";

    services.bee.settings = {
      data-dir             = lib.mkDefault "/var/lib/bee";
      password-file        = lib.mkDefault "/var/lib/bee/password";
      clef-signer-enable   = lib.mkDefault true;
      clef-signer-endpoint = lib.mkDefault "/var/lib/bee-clef/clef.ipc";
      swap-endpoint        = lib.mkDefault "https://rpc.slock.it/goerli";
    };

    systemd.packages = [ cfg.package ]; # include the upstream bee.service file

    systemd.tmpfiles.rules = [
      "d '${cfg.settings.data-dir}' 0750 ${cfg.user} ${cfg.group}"
    ];

    systemd.services.bee = {
      requires = optional config.services.bee-clef.enable
        "bee-clef.service";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Nice = cfg.daemonNiceLevel;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = [
          "" # this hides/overrides what's in the original entry
          "${cfg.package}/bin/bee --config=${configFile} start"
        ];
      };

      preStart = with cfg.settings; ''
        if ! test -f ${password-file}; then
          < /dev/urandom tr -dc _A-Z-a-z-0-9 2> /dev/null | head -c32 > ${password-file}
          chmod 0600 ${password-file}
          echo "Initialized ${password-file} from /dev/urandom"
        fi
        if [ ! -f ${data-dir}/keys/libp2p.key ]; then
          ${cfg.package}/bin/bee init --config=${configFile} >/dev/null
          echo "
Logs:   journalctl -f -u bee.service

Bee has SWAP enabled by default and it needs ethereum endpoint to operate.
It is recommended to use external signer with bee.
Check documentation for more info:
- SWAP https://docs.ethswarm.org/docs/installation/manual#swap-bandwidth-incentives
- External signer https://docs.ethswarm.org/docs/installation/bee-clef

After you finish configuration run 'sudo bee-get-addr'."
        fi
      '';
    };

    users.users = optionalAttrs (cfg.user == "bee") {
      bee = {
        group = cfg.group;
        home = cfg.settings.data-dir;
        isSystemUser = true;
        description = "Daemon user for Ethereum Swarm Bee";
        extraGroups = optional config.services.bee-clef.enable
          config.services.bee-clef.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "bee") {
      bee = {};
    };
  };
}
