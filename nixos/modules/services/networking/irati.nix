{ config, lib, pkgs, ... }:

with lib;

let
  kernel = config.boot.kernelPackages;

  cfg = config.networking.rina.irati;
  configFile = pkgs.writeText "ipcmanager.conf" (builtins.toJSON {
    configFileVersion = "1.4.1";
    difConfigurations = map mkDifConfig cfg.difs;
    ipcProcessesToCreate = cfg.ipcps;
    localConfiguration = {
      consoleSocket = "/run/ipcm-console.sock";
      installationPath = "${pkgs.irati.rinad}/bin";
      libraryPath = "${pkgs.irati.rinad.lib}/lib";
      logPath = "/var/log/irati";
      pluginsPaths = cfg.pluginsPaths ++ [
        "${pkgs.irati.rinad.lib}/lib/rinad/ipcp"
        "${kernel.irati}/lib/modules/${kernel.kernel.modDirVersion}/extra"
      ];
    };
  });

  mkDifConfig = cfg: {
    inherit (cfg) name;
    template = (cfg.template or "default") + ".dif";
  } // cfg.extraConfig;

  mkDifTemplate = name: cfg: pkgs.writeText "${name}.dif" (builtins.toJSON cfg);

  defaultDif = pkgs.runCommand "default.dif" {} ''
    # Overrides with provided default dif with extra json from
    # cfg.templates.default.
    ${pkgs.jq}/bin/jq -s '.[0] * .[1]'     \
        ${pkgs.irati.rinad.out}/etc/default.dif \
        ${pkgs.writeText "extra-default.dif" (builtins.toJSON cfg.templates.default or {})} \
        > $out
  '';

  daMap = pkgs.writeText "da.map" (builtins.toJSON {
    applicationToDIFMappings = [ ];
  });

  configs = [
    configFile
    defaultDif
    daMap
  ] ++ mapAttrsToList mkDifTemplate (filterAttrs (n: v: n != "default") cfg.templates);

  configDirOld = pkgs.linkFarm "etc-rinad" (map (cfg: { inherit (cfg) name; path = cfg; }));
  configDir = "/etc/irati";
  etc = listToAttrs (map (cfg: nameValuePair "irati/${cfg.name}" { source = cfg; }) configs);

in {
  options = {
    networking.rina.irati = {
      enable = mkOption {
        default = false;
        description = ''
          Enable the IRATI implementation of the Recursive Internet Architecture.
        '';
      };

      pluginsPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "A list of directories which contain ipcm plugins.";
      };

      templates = mkOption {
        type = types.attrsOf types.unspecified;
        default = { };
        description = ''
          DIF templates which will be converted to json .dif files.
        '';
      };

      difs = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                Name of the DIF.
              '';
            };

            template = mkOption {
              type = types.str;
              default = "default";
              description = ''
                Name of one of the defined templates
              '';
            };

            extraConfig = mkOption {
              type = types.attrs;
              default = { };
              description = ''
                Extra configuration attrs added to the DIF json.
              '';
            };
          };
        });
        description = ''
          The DIFs.
        '';
        default = [ ];
        example = [
          { name = "110";
            template = "shim-eth-vlan";
          }
          { name = "normal.DIF";
          }
        ];
      };

      ipcps = mkOption {
        type = types.listOf types.unspecified;
        default = [];
        example = [
            {
              apInstance = "1";
              apName = "test-eth-vlan";
              difName = "110";
              type = "shim-eth-vlan";
            }
            {
              apInstance = "1";
              apName = "test1.IRATI";
              difName = "normal.DIF";
              difsToRegisterAt = [ "110" ];
              type = "normal-ipc";
            }
        ];
        description = ''
          The IPC processes to create.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.irati.rina-tools ];

    boot = {
      kernelModules = [
        "rina_irati_core"
        "rina_default_plugin"
        "normal-ipcp"
        "shim-eth-vlan"
        "shim-tcp-udp"
      ];
      extraModulePackages = [ kernel.irati ];
    };

    systemd.services.rina-ipcm = {
      description = "RINA IPC Manager Daemon";

      before = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.irati.rinad}/bin/ipcm -c ${configDir}/ipcmanager.conf";
        LogsDirectory = "irati";
      };
    };

    powerManagement.resumeCommands = ''
      ${config.systemd.package}/bin/systemctl try-restart rina-ipcm
    '';

    environment.etc = etc;
  };

  meta.maintainers = with lib.maintainers; [ rvl ];
}
