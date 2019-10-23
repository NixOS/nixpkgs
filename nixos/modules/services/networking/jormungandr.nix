{ config, lib, pkgs, ... }:

let
  cfg = config.services.jormungandr;

  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib) optionalString types;

  dataDir = "/var/lib/jormungandr";

  # Default settings so far, as the service matures we will
  # move these out as separate settings
  configSettings = {
    storage = dataDir;
    p2p = {
      public_address = "/ip4/127.0.0.1/tcp/8299";
      topics_of_interest = {
        messages = "high";
        blocks = "high";
      };
    };
    rest = {
      listen = "127.0.0.1:8607";
    };
  };

  configFile = if cfg.configFile == null then
    pkgs.writeText "jormungandr.yaml" (builtins.toJSON configSettings)
  else cfg.configFile;

in {

  options = {

    services.jormungandr = {
      enable = mkEnableOption "jormungandr service";

      configFile = mkOption {
       type = types.nullOr types.path;
       default = null;
       example = "/var/lib/jormungandr/node.yaml";
       description = ''
         The path of the jormungandr blockchain configuration file in YAML format.
         If no file is specified, a file is generated using the other options.
       '';
     };

      secretFile = mkOption {
       type = types.nullOr types.path;
       default = null;
       example = "/etc/secret/jormungandr.yaml";
       description = ''
         The path of the jormungandr blockchain secret node configuration file in
         YAML format. Do not store this in nix store!
       '';
     };

      genesisBlockHash = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "d70495af81ae8600aca3e642b2427327cb6001ec4d7a0037e96a00dabed163f9";
        description = ''
          Set the genesis block hash (the hash of the block0) so we can retrieve
          the genesis block (and the blockchain configuration) from the existing
          storage or from the network.
        '';
      };

      genesisBlockFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/jormungandr/block-0.bin";
        description = ''
          The path of the genesis block file if we are hosting it locally.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.services.jormungandr = {
      description = "jormungandr server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      environment = {
        RUST_BACKTRACE = "full";
      };
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDir;
        ExecStart = ''
          ${pkgs.jormungandr}/bin/jormungandr --config ${configFile} \
            ${optionalString (cfg.secretFile != null) " --secret ${cfg.secretFile}"} \
            ${optionalString (cfg.genesisBlockHash != null) " --genesis-block-hash ${cfg.genesisBlockHash}"} \
            ${optionalString (cfg.genesisBlockFile != null) " --genesis-block ${cfg.genesisBlockFile}"}
        '';
      };
    };
  };
}
