{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cryptpad;
in
{
  options.services.cryptpad = {
    enable = mkEnableOption "the Cryptpad service";

    package = mkOption {
      default = pkgs.cryptpad;
      defaultText = "pkgs.cryptpad";
      type = types.package;
      description = "
        Cryptpad package to use.
      ";
    };

    settings = let
      baseTypes = with types; (oneOf [
        int bool str
        (listOf str) (attrsOf baseTypes)
      ]) // { description = "Valid base types"; };

      topLevel = with types; attrsOf (baseTypes // {
        description = ''
          An attribute set with valid types being an integer, boolean, string,
          an array of strings, or another attrset with the same possible values.
        '';
      });
    in mkOption {
      type = topLevel;
      default = {};
      description = ''
        Cryptpad settings using Nix. Requires configFile to be null.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = "${cfg.package}/lib/node_modules/cryptpad/config/config.example.js";
      defaultText = "\${cfg.package}/lib/node_modules/cryptpad/config/config.example.js";
      description = ''
        Path to the JavaScript configuration file.

        See <link
        xlink:href="https://github.com/xwiki-labs/cryptpad/blob/master/config/config.example.js"/>
        for a configuration example.
      '';
    };
  };

  config = let
    configFile = if cfg.configFile != null
      then cfg.configFile
      else pkgs.writeText "cryptpad-config.js" ''
        module.exports = ${builtins.toJSON cfg.settings};
      '';
  in mkIf cfg.enable {
    systemd.services.cryptpad = {
      description = "Cryptpad Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        DynamicUser = true;
        Environment = [
          "CRYPTPAD_CONFIG=${configFile}"
          "HOME=%S/cryptpad"
        ];
        ExecStart = "${cfg.package}/bin/cryptpad";
        PrivateTmp = true;
        Restart = "always";
        StateDirectory = "cryptpad";
        WorkingDirectory = "%S/cryptpad";
      };
    };

    services.cryptpad.settings = mapAttrs (_: v: mkDefault v) {
      # Explicit defaults
      httpUnsafeOrigin = "http://localhost:3000/";
      adminEmail = "i.did.not.read.my.config@cryptpad.fr";
      filePath = "./datastore/";
      archivePath = "./data/archive";
      pinPath = "./data/pins";
      taskPath = "./data/tasks";
      blockPath = "./block";
      blobPath = "./blob";
      blobStagingPath = "./data/blobstage";
      logPath = "./data/logs";
      logToStdout = false;
      logLevel = "info";
      logFeedback = false;
      verbose = false;
    };
  };
}
