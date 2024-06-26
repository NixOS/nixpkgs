{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  eachBlockbook = config.services.blockbook-frontend;

  blockbookOpts =
    {
      config,
      lib,
      name,
      ...
    }:
    {

      options = {

        enable = mkEnableOption "blockbook-frontend application";

        package = mkPackageOption pkgs "blockbook" { };

        user = mkOption {
          type = types.str;
          default = "blockbook-frontend-${name}";
          description = "The user as which to run blockbook-frontend-${name}.";
        };

        group = mkOption {
          type = types.str;
          default = "${config.user}";
          description = "The group as which to run blockbook-frontend-${name}.";
        };

        certFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/etc/secrets/blockbook-frontend-${name}/certFile";
          description = ''
            To enable SSL, specify path to the name of certificate files without extension.
            Expecting {file}`certFile.crt` and {file}`certFile.key`.
          '';
        };

        configFile = mkOption {
          type = with types; nullOr path;
          default = null;
          example = "${config.dataDir}/config.json";
          description = "Location of the blockbook configuration file.";
        };

        coinName = mkOption {
          type = types.str;
          default = "Bitcoin";
          description = ''
            See <https://github.com/trezor/blockbook/blob/master/bchain/coins/blockchain.go#L61>
            for current of coins supported in master (Note: may differ from release).
          '';
        };

        cssDir = mkOption {
          type = types.path;
          default = "${config.package}/share/css/";
          defaultText = literalExpression ''"''${package}/share/css/"'';
          example = literalExpression ''"''${dataDir}/static/css/"'';
          description = ''
            Location of the dir with {file}`main.css` CSS file.
            By default, the one shipped with the package is used.
          '';
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/blockbook-frontend-${name}";
          description = "Location of blockbook-frontend-${name} data directory.";
        };

        debug = mkOption {
          type = types.bool;
          default = false;
          description = "Debug mode, return more verbose errors, reload templates on each request.";
        };

        internal = mkOption {
          type = types.nullOr types.str;
          default = ":9030";
          description = "Internal http server binding `[address]:port`.";
        };

        messageQueueBinding = mkOption {
          type = types.str;
          default = "tcp://127.0.0.1:38330";
          description = "Message Queue Binding `address:port`.";
        };

        public = mkOption {
          type = types.nullOr types.str;
          default = ":9130";
          description = "Public http server binding `[address]:port`.";
        };

        rpc = {
          url = mkOption {
            type = types.str;
            default = "http://127.0.0.1";
            description = "URL for JSON-RPC connections.";
          };

          port = mkOption {
            type = types.port;
            default = 8030;
            description = "Port for JSON-RPC connections.";
          };

          user = mkOption {
            type = types.str;
            default = "rpc";
            description = "Username for JSON-RPC connections.";
          };

          password = mkOption {
            type = types.str;
            default = "rpc";
            description = ''
              RPC password for JSON-RPC connections.
              Warning: this is stored in cleartext in the Nix store!!!
              Use `configFile` or `passwordFile` if needed.
            '';
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              File containing password of the RPC user.
              Note: This options is ignored when `configFile` is used.
            '';
          };
        };

        sync = mkOption {
          type = types.bool;
          default = true;
          description = "Synchronizes until tip, if together with zeromq, keeps index synchronized.";
        };

        templateDir = mkOption {
          type = types.path;
          default = "${config.package}/share/templates/";
          defaultText = literalExpression ''"''${package}/share/templates/"'';
          example = literalExpression ''"''${dataDir}/templates/static/"'';
          description = "Location of the HTML templates. By default, ones shipped with the package are used.";
        };

        extraConfig = mkOption {
          type = types.attrs;
          default = { };
          example = literalExpression ''
            {
                     "alternative_estimate_fee" = "whatthefee-disabled";
                     "alternative_estimate_fee_params" = "{\"url\": \"https://whatthefee.io/data.json\", \"periodSeconds\": 60}";
                     "fiat_rates" = "coingecko";
                     "fiat_rates_params" = "{\"url\": \"https://api.coingecko.com/api/v3\", \"coin\": \"bitcoin\", \"periodSeconds\": 60}";
                     "coin_shortcut" = "BTC";
                     "coin_label" = "Bitcoin";
                     "parse" = true;
                     "subversion" = "";
                     "address_format" = "";
                     "xpub_magic" = 76067358;
                     "xpub_magic_segwit_p2sh" = 77429938;
                     "xpub_magic_segwit_native" = 78792518;
                     "mempool_workers" = 8;
                     "mempool_sub_workers" = 2;
                     "block_addresses_to_keep" = 300;
                   }'';
          description = ''
            Additional configurations to be appended to {file}`coin.conf`.
            Overrides any already defined configuration options.
            See <https://github.com/trezor/blockbook/tree/master/configs/coins>
            for current configuration options supported in master (Note: may differ from release).
          '';
        };

        extraCmdLineOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "-workers=1"
            "-dbcache=0"
            "-logtosderr"
          ];
          description = ''
            Extra command line options to pass to Blockbook.
            Run blockbook --help to list all available options.
          '';
        };
      };
    };
in
{
  # interface

  options = {
    services.blockbook-frontend = mkOption {
      type = types.attrsOf (types.submodule blockbookOpts);
      default = { };
      description = "Specification of one or more blockbook-frontend instances.";
    };
  };

  # implementation

  config = mkIf (eachBlockbook != { }) {

    systemd.services = mapAttrs' (
      blockbookName: cfg:
      (nameValuePair "blockbook-frontend-${blockbookName}" (
        let
          configFile =
            if cfg.configFile != null then
              cfg.configFile
            else
              pkgs.writeText "config.conf" (
                builtins.toJSON (
                  {
                    coin_name = "${cfg.coinName}";
                    rpc_user = "${cfg.rpc.user}";
                    rpc_pass = "${cfg.rpc.password}";
                    rpc_url = "${cfg.rpc.url}:${toString cfg.rpc.port}";
                    message_queue_binding = "${cfg.messageQueueBinding}";
                  }
                  // cfg.extraConfig
                )
              );
        in
        {
          description = "blockbook-frontend-${blockbookName} daemon";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            ln -sf ${cfg.templateDir} ${cfg.dataDir}/static/
            ln -sf ${cfg.cssDir} ${cfg.dataDir}/static/
            ${optionalString (cfg.rpc.passwordFile != null && cfg.configFile == null) ''
              CONFIGTMP=$(mktemp)
              ${pkgs.jq}/bin/jq ".rpc_pass = \"$(cat ${cfg.rpc.passwordFile})\"" ${configFile} > $CONFIGTMP
              mv $CONFIGTMP ${cfg.dataDir}/${blockbookName}-config.json
            ''}
          '';
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = ''
              ${cfg.package}/bin/blockbook \
              ${
                if (cfg.rpc.passwordFile != null && cfg.configFile == null) then
                  "-blockchaincfg=${cfg.dataDir}/${blockbookName}-config.json"
                else
                  "-blockchaincfg=${configFile}"
              } \
              -datadir=${cfg.dataDir} \
              ${optionalString (cfg.sync != false) "-sync"} \
              ${optionalString (cfg.certFile != null) "-certfile=${toString cfg.certFile}"} \
              ${optionalString (cfg.debug != false) "-debug"} \
              ${optionalString (cfg.internal != null) "-internal=${toString cfg.internal}"} \
              ${optionalString (cfg.public != null) "-public=${toString cfg.public}"} \
              ${toString cfg.extraCmdLineOptions}
            '';
            Restart = "on-failure";
            WorkingDirectory = cfg.dataDir;
            LimitNOFILE = 65536;
          };
        }
      ))
    ) eachBlockbook;

    systemd.tmpfiles.rules = flatten (
      mapAttrsToList (blockbookName: cfg: [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/static 0750 ${cfg.user} ${cfg.group} - -"
      ]) eachBlockbook
    );

    users.users = mapAttrs' (
      blockbookName: cfg:
      (nameValuePair "blockbook-frontend-${blockbookName}" {
        name = cfg.user;
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
      })
    ) eachBlockbook;

    users.groups = mapAttrs' (instanceName: cfg: (nameValuePair "${cfg.group}" { })) eachBlockbook;
  };

  meta.maintainers = with maintainers; [ _1000101 ];

}
