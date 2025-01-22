{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.rathole;
  settingsFormat = pkgs.formats.toml { };
  py-toml-merge =
    pkgs.writers.writePython3Bin "py-toml-merge"
      {
        libraries = with pkgs.python3Packages; [
          tomli-w
          mergedeep
        ];
      }
      ''
        import argparse
        from pathlib import Path
        from typing import Any

        import tomli_w
        import tomllib
        from mergedeep import merge

        parser = argparse.ArgumentParser(description="Merge multiple TOML files")
        parser.add_argument(
            "files",
            type=Path,
            nargs="+",
            help="List of TOML files to merge",
        )

        args = parser.parse_args()
        merged: dict[str, Any] = {}

        for file in args.files:
            with open(file, "rb") as fh:
                loaded_toml = tomllib.load(fh)
                merged = merge(merged, loaded_toml)

        print(tomli_w.dumps(merged))
      '';
in

{
  options = {
    services.rathole = {
      enable = lib.mkEnableOption "Rathole";

      package = lib.mkPackageOption pkgs "rathole" { };

      role = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        description = ''
          Select whether rathole needs to be run as a `client` or a `server`.
          Server is a machine with a public IP and client is a device behind NAT,
          but running some services that need to be exposed to the Internet.
        '';
      };

      credentialsFile = lib.mkOption {
        type = lib.types.path;
        default = "/dev/null";
        description = ''
          Path to a TOML file to be merged with the settings.
          Useful to set secret config parameters like tokens, which
          should not appear in the Nix Store.
        '';
        example = "/var/lib/secrets/rathole/config.toml";
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          Rathole configuration, for options reference
          see the [example](https://github.com/rapiz1/rathole?tab=readme-ov-file#configuration) on GitHub.
          Both server and client configurations can be specified at the same time, regardless of the selected role.
        '';
        example = {
          server = {
            bind_addr = "0.0.0.0:2333";
            services.my_nas_ssh = {
              token = "use_a_secret_that_only_you_know";
              bind_addr = "0.0.0.0:5202";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.rathole = {
      requires = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Rathole ${cfg.role} Service";

      serviceConfig =
        let
          name = "rathole";
          configFile = settingsFormat.generate "${name}.toml" cfg.settings;
          runtimeDir = "/run/${name}";
          ratholePrestart =
            "+"
            + (pkgs.writeShellScript "rathole-prestart" ''
              DYNUSER_UID=$(stat -c %u ${runtimeDir})
              DYNUSER_GID=$(stat -c %g ${runtimeDir})
              ${lib.getExe py-toml-merge} ${configFile} '${cfg.credentialsFile}' |
                install -m 600 -o $DYNUSER_UID -g $DYNUSER_GID /dev/stdin ${runtimeDir}/${mergedConfigName}
            '');
          mergedConfigName = "merged.toml";
        in
        {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 5;
          ExecStartPre = ratholePrestart;
          ExecStart = "${lib.getExe cfg.package} --${cfg.role} ${runtimeDir}/${mergedConfigName}";
          DynamicUser = true;
          LimitNOFILE = "1048576";
          RuntimeDirectory = name;
          RuntimeDirectoryMode = "0700";
          # Hardening
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          # PrivateUsers=true breaks AmbientCapabilities=CAP_NET_BIND_SERVICE
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0066";
        };
    };
  };

  meta.maintainers = with lib.maintainers; [ xokdvium ];
}
