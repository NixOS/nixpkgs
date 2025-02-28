# Fusion Inventory daemon.
{ config, lib, pkgs, ... }:
let
  cfg = config.services.fusionInventory;

  configFile = pkgs.writeText "fusion_inventory.conf" ''
    server = ${lib.concatStringsSep ", " cfg.servers}

    logger = stderr

    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    services.fusionInventory = {

      enable = lib.mkEnableOption "Fusion Inventory Agent";

      servers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          The urls of the OCS/GLPI servers to connect to.
        '';
      };

      extraConfig = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Configuration that is injected verbatim into the configuration file.
        '';
      };
    };
  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users.fusion-inventory = {
      description = "FusionInventory user";
      isSystemUser = true;
    };

    systemd.services.fusion-inventory = {
      description = "Fusion Inventory Agent";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.fusionInventory}/bin/fusioninventory-agent --conf-file=${configFile} --daemon --no-fork";
      };
    };
  };
}
