{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.vintagestory;
in
{
  options.services.vintagestory = {
    enable = lib.mkEnableOption "Vintagestory server";
    package = lib.mkPackageOption pkgs "vintagestory" { };

    host = lib.mkOption {
      description = "The address that the server will bind to";
      default = null;
      example = "127.0.0.1";
      type = with lib.types; nullOr singleLineStr;
    };

    port = lib.mkOption {
      description = "The port that the server will bind to";
      default = 42420;
      type = lib.types.ints.between 1 65535;
    };

    maxClients = lib.mkOption {
      description = "The maximum amount of players that are allowed to join";
      default = 16;
      type = lib.types.int;
    };

    configPath = lib.mkOption {
      description = "The path to the config file. Must be a nix store path.";
      default = null;
      example = lib.literalExpression "./config";
      type = with lib.types; nullOr path;
    };

    dataPath = lib.mkOption {
      description = "The path to store the server's state in";
      default = "/var/lib/vintagestory";
      example = "/var/lib/vintagestory-2";
      type = lib.types.path;
    };

    extraFlags = lib.mkOption {
      description = "Extra flags to pass to the server";
      default = [ ];
      type = with lib.types; listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.configPath == null) || lib.isStorePath cfg.configPath;
        message = "The config file must reside in the nix store";
      }
    ];

    networking.firewall.allowedUDPPorts = [ cfg.port ];

    systemd.services.vintagestory = {
      description = "Vintagestory server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        ${lib.getExe' cfg.package "vintagestory-server"} \
          ${lib.optionalString (cfg.host != null) "--ip ${cfg.host}"} \
          --port ${builtins.toString cfg.port} \
          --maxclients ${builtins.toString cfg.maxClients} \
          --dataPath ${cfg.dataPath} \
          --withconfig "${lib.readFile cfg.configPath}" \
          ${lib.concatStringsSep " " cfg.extraFlags}
      '';

      serviceConfig = {
        DynamicUser = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ dtomvan ];
}
