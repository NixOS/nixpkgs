{ config, pkgs, lib, utils, ... }:
let
  inherit (utils) escapeSystemdPath;
  inherit (lib) mdDoc mkOption mkMerge mkIf mkEnableOption types;
  cfg = config.environment.dotd;
in {
  options = {
    environment.dotd = mkOption {
      description = mdDoc "Module to create .d like directories and special files that when read get the contents of the files in the .d folder in sort order";
      default = {};
      example = {
        "nix/machines".enable = true;
        "i3/config".enable = true;
      };
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption (mdDoc "Create this file, create it's .d folder and the required stuff to make the file get the contents from the files inside the .d folder");
        };
      });
    };
  };
  config.systemd = let
      dotdKeys = builtins.attrNames cfg;
  in mkMerge  (builtins.map (key: let
      item = cfg.${key};
      normalizedKey = escapeSystemdPath key;
    in {
      tmpfiles.rules = [
        "p+ \"${key}\" 0644 root root" # recreate the named pipe
        "d \"${key}.d\" 0755 root root" # create the .d folder but don't clean it periodically
      ];
      paths."dotd-${normalizedKey}-watcher" = {
        inherit (item) enable;
        wantedBy = [ "default.target" ];
        pathConfig = {
          PathChanged = "${key}.d";
        };
      };
      services = {
        "dotd-${normalizedKey}-watcher" = {
          inherit (item) enable;
          script = ''
            echo "Reacting to file change..."
            systemctl restart "dotd-${normalizedKey}"
          '';
        };
        "dotd-${normalizedKey}" = {
          inherit (item) enable;
          restartIfChanged = true;
          wantedBy = [ "default.target" ];
          environment = {
            DOTD_FILE = "${key}";
            DOTD_FOLDER = "${key}.d";
          };
          script = ''
            while true; do
              echo Someone accessed the named pipe >&2
              ls -1 "$DOTD_FOLDER" | sort | while read file; do
                cat "$DOTD_FOLDER/$file"
              done > "$DOTD_FILE"
            done
          '';
        };
      };
    }) dotdKeys);
}
