{
  config,
  lib,
  hostPkgs,
  ...
}:
let
  inherit (lib) types;

  displayTarget = types.submodule {
    options = {
      backend = lib.mkOption {
        internal = true;
        type = types.enum [ "x11" ];
      };
      display = lib.mkOption {
        internal = true;
        type = types.str;
      };
      xauthority = lib.mkOption {
        internal = true;
        type = types.str;
      };
    };
  };

  machineConfigurationAttrs =
    extraOptions:
    lib.mkOption {
      internal = true;
      type = types.attrsOf (
        types.submodule {
          options = {
            name = lib.mkOption {
              internal = true;
              type = types.str;
            };
            start_script = lib.mkOption {
              internal = true;
              type = types.path;
            };
          }
          // extraOptions;
        }
      );
    };
in
{
  options = {
    driverConfiguration = lib.mkOption {
      description = "Configuration attribute set for test driver invocation";
      internal = true;
      type = types.submodule {
        options = {
          vms = machineConfigurationAttrs { };
          containers = machineConfigurationAttrs {
            display_targets = lib.mkOption {
              internal = true;
              type = types.listOf displayTarget;
              default = [ ];
            };
          };
          vlans = lib.mkOption {
            internal = true;
            type = types.listOf types.ints.unsigned;
          };
          global_timeout = lib.mkOption {
            internal = true;
            type = types.ints.unsigned;
          };
          enable_ssh_backdoor = lib.mkOption {
            internal = true;
            type = types.bool;
          };
          test_script = lib.mkOption {
            internal = true;
            type = types.path;
          };
        };
      };
    };
    driverConfigurationFile = lib.mkOption {
      internal = true;
      type = types.path;
    };
  };

  config = {
    driverConfiguration = {
      vms = lib.mapAttrs (name: value: {
        inherit name;
        start_script = lib.getExe value.system.build.vm;
      }) config.nodes;
      containers = lib.mapAttrs (name: value: {
        inherit name;
        start_script = lib.getExe value.system.build.nspawn;
        display_targets = value.testing.displayTargets;
      }) config.containers;
      vlans = lib.unique (
        lib.concatMap (
          m: (m.virtualisation.vlans ++ (lib.mapAttrsToList (_: v: v.vlan) m.virtualisation.interfaces))
        ) (lib.attrValues config.nodes ++ lib.attrValues config.containers)
      );
      global_timeout = config.globalTimeout;
      test_script = hostPkgs.writeText "test-script" config.testScriptString;
      enable_ssh_backdoor = config.sshBackdoor.enable;
    };
    driverConfigurationFile = hostPkgs.writers.writeJSON "driverConfiguration.json" config.driverConfiguration;
  };
}
