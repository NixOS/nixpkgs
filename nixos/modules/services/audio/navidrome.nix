{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.navidrome;
  settingsFormat = pkgs.formats.json {};
in {
  options = {
    services.navidrome = {
      enable = mkEnableOption pkgs.navidrome.meta.description;
      settings = mkOption rec {
        type = settingsFormat.type;
        apply = recursiveUpdate default;
        default = {
          Address = "127.0.0.1";
          Port = 4533;
        };
        example = {
          MusicFolder = "/mnt/music";
        };
        description = ''
          Configuration for Navidrome, see <link xlink:href="https://www.navidrome.org/docs/usage/configuration-options/"/> for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.navidrome ];

    systemd.services.navidrome = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.navidrome}/bin/navidrome --configfile ${settingsFormat.generate "navidrome.json" cfg.settings}"
        ];
        DynamicUser = true;
        StateDirectory = "navidrome";
        RuntimeDirectory = "navidrome";
        RootDirectory = "/run/navidrome";
        ReadWritePaths = "";
        BindReadOnlyPaths = [
          builtins.storeDir
        ] ++ lib.optional (cfg.settings ? MusicFolder) cfg.settings.MusicFolder;
        CapabilityBoundingSet = "";
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        SystemCallFilter = [ "~@resources" "~@cpu-emulation" ];
        SystemCallArchitectures = "native";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        UMask = "0066";
        ProtectHostname = true;
      };
    };
  };
}
