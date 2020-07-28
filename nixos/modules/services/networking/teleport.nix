{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.teleport;

  # Pretty-print JSON to a file
  writePrettyJSON = name: x:
    pkgs.runCommand name { } "
      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out
    ";
  # This becomes the main config file
  # To be used in the future when I add seperate option sections for each part of teleport
  # Rather then writing a single yaml file directly into your nix file.
  telConfig = {
    global = cfg.globalConfig;
    rule_files = cfg.ruleFiles ++ [
      (pkgs.writeText "teleport.rules" (concatStringsSep "\n" cfg.rules))
    ];
  };

  generatedTeleportYml = writePrettyJSON "teleport.yaml" telConfig;

  teleportYml =
    if cfg.configText != null then
      pkgs.writeText "teleport.yml" cfg.configText
    else generatedTeleportYml;

  cmdlineArgs = "-c ${teleportYml}";

in

{
  options = {
    services.teleport = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "
          Enable the Teleport Cluster SSH daemon.
        ";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teleport/";
        description = "
          Directory to store Teleport Service data.
        ";
      };
      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "
          If non-null, this option defines the text that is written to
          teleport.yml.
        ";
      };
    };
  };

    config = mkIf cfg.enable {
      systemd.services.teleport = {
        wantedBy = [ "multi-user.target" ];
        after    = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.teleport}/bin/teleport start ${cmdlineArgs}" --pid-file=/run/teleport.pid;
          ExecReload = "/run/current-system/sw/bin/kill -HUP $MAINPID";
          PIDFile = "run/teleport.pid";
          Restart  = "on-failure";
          WorkingDirectory = ${cfg.dataDir};
        };
      };
   };
}
