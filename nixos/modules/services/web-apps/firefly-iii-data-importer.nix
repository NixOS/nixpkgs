{ pkgs, config, lib, ... }:
let cfg = config.services.firefly-iii.data-importer;
in {
  options.services.firefly-iii.data-importer = {
    enable = lib.mkEnableOption "Firefly-iii Data importer service";

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address on which the service should listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description =
        "Port on which to serve the Firefly-iii Data importer service.";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = ''
        Configuration of the Firefly-iii Data importer service.

        See [the documentation](https://docs.firefly-iii.org/how-to/data-importer/how-to-configure/) for available options and default values.
      '';
      example = { FIREFLY_III_URL = "http://app.url:8000"; };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.firefly-iii-data-importer = {
      description = "Firefly-iii Data importer service";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        STORAGE_PATH = "/var/lib/firefly-iii-data-importer";
      } // (builtins.mapAttrs (_: val: toString val) cfg.settings);

      serviceConfig.StateDirectory = "firefly-iii-data-importer";
      serviceConfig.DynamicUser = true;
      script = ''
        # Initialize the storage directories
        cp -r ${pkgs.firefly-iii-data-importer}/storage/* $STORAGE_PATH/
        chmod -R 770 $STORAGE_PATH/
        ${lib.getExe pkgs.php83} -S ${cfg.listenAddress}:${
          builtins.toString cfg.port
        } -t ${pkgs.firefly-iii-data-importer}/public
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ litchipi ];
}
