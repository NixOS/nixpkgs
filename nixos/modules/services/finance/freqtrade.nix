{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.freqtrade;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.freqtrade =
    with {
      inherit (lib) mkOption mkEnableOption;
      inherit (lib.types)
        str
        bool
        port
        submodule
        lazyAttrsOf
        nullOr
        listOf
        path
        externalPath
        ;
    };
    let
      genCommonOptions = type: cfg: parentCfg: {
        settings = mkOption {
          description =
            let
              prefix = lib.optionalString (type == "root") "Global ";
              object =
                if type == "root" then
                  "all bots and webserver that get merged with [`lib.recursiveUpdate`](https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.attrsets.recursiveUpdate)"
                else
                  "the ${type}";
            in
            "${prefix}Freqtrade config for ${object}. See [Freqtrade documentation](https://www.freqtrade.io/en/stable/configuration/) for possible key and vaules.";
          type = submodule (
            { name, config, ... }:

            let
              getSetting = key: config.${key} or cfg.settings.${key} or parentCfg.settings.${key};
            in
            {
              freeformType = settingsFormat.type;
              options =
                let
                  genCfgAttrPath = rec {
                    cfg =
                      optionAttrPath:
                      let
                        nonRootAttrPath =
                          lib.optionalString (type != "root")
                            ".${
                              if type == "bot" then
                                "bot.${name}"
                              else if type == "webserver" then
                                type
                              else
                                throw "Unknown type."
                            }";
                      in
                      "config.services.freqtrade${nonRootAttrPath}.${optionAttrPath}";
                    parentCfg =
                      operator: optionAttrPath:
                      lib.optionalString (type != "root") " ${operator} config.services.freqtrade.${optionAttrPath}";
                    cfgOperatorParent =
                      optionAttrPath: operator: cfg optionAttrPath + parentCfg operator optionAttrPath;
                  };
                in
                {
                  dry_run = mkOption {
                    description =
                      let
                        object = if type == "root" then "all bots and webserver" else type;
                        suffix = lib.optionalString (type == "root") " by default";
                      in
                      "Define if ${object} must be in Dry Run or production mode${suffix}.";
                    type = bool;
                    default = parentCfg.settings.dry_run or true;
                    defaultText = lib.literalExpression (
                      lib.optionalString (type != "root") "config.services.freqtrade.settings.dry_run or " + "true"
                    );
                  };
                  add_config_files = mkOption {
                    description = "Additional config files. These files will be merged with the nix config using merge strategy like the nix [update operator `//`](https://nix.dev/manual/nix/2.34/language/operators#update).";
                    type = listOf path;
                    default = cfg.extraConfigFiles ++ parentCfg.extraConfigFiles or [ ];
                    defaultText = lib.literalExpression (genCfgAttrPath.cfgOperatorParent "extraConfigFiles" "++");
                  };
                  user_data_dir = mkOption {
                    description = "Directory containing user data.";
                    type = externalPath;
                    default =
                      let
                        result = lib.tryEval cfg.userDataDir;
                      in
                      if result.success then result.value else parentCfg.userDataDir;
                    defaultText = lib.literalExpression (genCfgAttrPath.cfgOperatorParent "userDataDir" "or");
                  };
                  db_url =
                    let
                      prefix = if config ? bot_name then "bot-${config.bot_name}" else "tradesv3";
                      suffix = lib.optionalString (getSetting "dry_run") ".dryrun";
                    in
                    mkOption {
                      description = "Declares database URL to use.";
                      type = str;
                      default = "sqlite://${getSetting "user_data_dir"}/db/${prefix}${suffix}.sqlite";
                      defaultText =
                        let
                          userDataDir = genCfgAttrPath.cfgOperatorParent "settings.user_data_dir" "or";
                          prefix =
                            if type == "bot" then
                              ''''${${genCfgAttrPath.cfg "settings.bot_name"} or "tradesv3"}''
                            else
                              "tradesv3";
                          suffix = ''lib.optionalString (${genCfgAttrPath.cfgOperatorParent "settings.dry_run" "or"}) ".dryrun"'';
                        in
                        lib.literalExpression "sqlite://\${${userDataDir}}/db/${prefix}\${${suffix}}.sqlite";
                    };
                };
            }
          );
          default = { };
          apply = value: lib.recursiveUpdate (parentCfg.settings or { }) value;
        };
        extraConfigFiles = mkOption {
          description = "Additional config files. These files will be merged with the nix config using merge strategy like the nix update operator `//`.";
          type = listOf path;
          default = [ ];
        };
        userDataDir = mkOption {
          description = "Directory containing user data.";
          type = externalPath;
        };
      };
    in
    {
      enable = mkEnableOption "Freqtrade, a free and open source crypto trading bot written in Python";
      bot = mkOption {
        description = "Instances of Freqtrade. For requirements about set multiple bots see [Running multiple instances of Freqtrade](https://www.freqtrade.io/en/stable/advanced-setup/#running-multiple-instances-of-freqtrade).";
        type = lazyAttrsOf (
          submodule (
            { name, config, ... }: {
              options = genCommonOptions "bot" config cfg;
              config.settings.bot_name = lib.mkDefault name;
            }
          )
        );
      };
      webserver = {
        enable = mkEnableOption "Freqtrade webserver, which using [FreqUI](https://www.freqtrade.io/en/stable/freq-ui/#webserver-mode) to download historical data, test pairlists, run backtesting and other commands";
        listen = {
          addr = mkOption {
            description = "Bind IP address. See the [API Server documentation](https://www.freqtrade.io/en/stable/rest-api/) for more details.";
            type = str;
          };
          port = mkOption {
            description = "Bind port. See the [API Server documentation](https://www.freqtrade.io/en/stable/rest-api/) for more details.";
            type = port;
          };
        };
      }
      // genCommonOptions "webserver" cfg.webserver cfg;
    }
    // genCommonOptions "root" cfg { };
  config =
    let
      genSystemdService = command: settingsJSON: {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${lib.getExe pkgs.freqtrade} ${command} --config ${settingsJSON}";
      };
      commonSystemdService = id: {
        # https://github.com/freqtrade/freqtrade/blob/6fa470939cc74bf0672e0e348a4d9b293072e43c/freqtrade.service.watchdog
        after = [ "network.target" ];
        serviceConfig = {
          # not using `Notify` and passing `--sd-notify` in `ExecStart` to prevent deadlock
          # due to `multi-user.target` of the container waits this unit
          # `ExecStart` of this unit waits for internet access before send `sd_notify()`: https://github.com/freqtrade/freqtrade/blob/158eac5609f13d5fdbd2b09106589a786ae9fcf9/freqtrade/worker.py#L67
          # and `ExecStartPost` of the host unit `container@.service` that setup `ip route` on the host side: https://github.com/NixOS/nixpkgs/blob/667d5cf1c59585031d743c78b394b0a647537c35/nixos/modules/virtualisation/nixos-containers.nix#L297
          # waits `multi-user.target` in the container as `systemd-nspawn` in `ExecStart` waits it: https://github.com/NixOS/nixpkgs/blob/667d5cf1c59585031d743c78b394b0a647537c35/nixos/modules/virtualisation/nixos-containers.nix#L198
          Type = "exec";
          Restart = "on-failure";
          SyslogIdentifier = "freqtrade-${id}";
        };
      };
    in
    lib.mkIf cfg.enable {
      services.freqtrade.webserver.settings.api_server = with cfg.webserver.listen; {
        enabled = true;
        listen_ip_address = addr;
        listen_port = port;
      };
      systemd.services = {
        "freqtrade@" = commonSystemdService "bot-%I";
        freqtrade-webserver = lib.mkIf cfg.webserver.enable (
          lib.mkMerge [
            (lib.pipe cfg.webserver.settings [
              (settingsFormat.generate "freqtrade-webserver-settings.json")
              (genSystemdService "webserver")
            ])
            (commonSystemdService "webserver")
          ]
        );
      }
      // lib.concatMapAttrs (name: botCfg: {
        "freqtrade@${name}" =
          (lib.pipe botCfg.settings [
            (settingsFormat.generate "freqtrade-bot-${name}-settings.json")
            (genSystemdService "trade")
          ])
          // {
            overrideStrategy = "asDropin"; # https://github.com/NixOS/nixpkgs/issues/80933#issuecomment-1295396500
          };
      }) cfg.bot;
    };
}
