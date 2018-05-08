{ config, lib, pkgs, ... }:

with lib;

let
  kernel = config.boot.kernelPackages;

  cfg = config.networking.rina.rlite;

  initScript = concatMapStringsSep "\n" (cmd: "rlite-ctl ${cmd}") (
    ["reset"]
    ++ concatMap ipcpSetup cfg.ipcps
    ++ concatLists (mapAttrsToList difSetup cfg.difs)
    ++ concatMap (ipcp: with ipcp; map (ipcpRegister apName) registerAt) cfg.ipcps
    ++ concatMap (ipcp: with ipcp; optional enrollerEnable "ipcp-enroller-enable ${escapeShellArg apName}") cfg.ipcps
    ++ concatMap (ipcp: with ipcp; map (ipcpEnroll apName) enrollments) cfg.ipcps
  );

  ipcpSetup = ipcp: with ipcp; [
    "ipcp-create ${escapeShellArg apName} ${type} ${escapeShellArg difName}"
    ] ++ (mapAttrsToList (ipcpConfig apName) params);

  ipcpConfig = apName: paramName: paramValue:
    "ipcp-config ${escapeShellArg apName} ${escapeShellArg paramName} ${escapeShellArg paramValue}";

  ipcpRegister = apName: difName: "ipcp-register ${escapeShellArg apName} ${escapeShellArg difName}";

  difSetup = difName: dif: with dif;
    mapAttrsToList (difPolicyMod difName) policy ++
    concatLists (mapAttrsToList (difPolicyParams difName) policyParams);

  difPolicyMod = difName: componentName: policyName:
    "dif-policy-mod ${escapeShellArgs [ difName componentName policyName ]}";
  difPolicyParams = difName: componentName: params: flip mapAttrsToList params
    (name: value: "dif-policy-param-mod ${escapeShellArgs [ difName componentName name value ]}");

  ipcpEnroll = apName: enroll: with enroll;
    "ipcp-enroll-retry ${escapeShellArgs ([ apName difName supportDIFName ] ++ optional (neighbourIPCPName != null) neighbourIPCPName)}";

in {
  options = {
    networking.rina.rlite = {
      enable = mkOption {
        default = false;
        description = ''
          Enable the rlite implementation of the Recursive Internet Architecture.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "QUIET" "WARN" "INFO" "DBG" "VERY" ];
        default = "DBG";
        description = ''
          Verbosity level of the userspace IPC processes daemon.
        '';
      };

      initCommands = mkOption {
        type = types.lines;
        default = "";
        example = "text=anything; echo You can put $text here.";
        description = ''
          Shell commands to be executed just after starting the
          <literal>rlite-uipcps</literal> systemd service.
        '';
      };

      difs = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            # name = mkOption {
            #   type = types.str;
            #   description = ''
            #     Name of the N-DIF under specification.
            #   '';
            # };

            lowerDIFs = mkOption {
              type = types.listOf types.str;
              description = ''
                Names of the N-1-DIFs (lower DIFs).
              '';
            };

            policy = mkOption {
              type = types.attrsOf types.str;
              description = ''
                Policy name for each component.
              '';
              example = { addralloc = "static"; };
              default = { };
            };

            policyParams = mkOption {
              type = with types; attrsOf (attrsOf (either bool (either int str)));
              description = ''
                Policy parameters for each component.
              '';
              example = { enrollment.keepalive = 10; };
              default = { };
            };
          };
        });
        description = ''
          Information about how this node participates in a specific N-DIF.
          It is used to specify what N-1 (lower) DIFs are used by the
          node to participate in the N-DIF.
        '';
        default = { };
        example = {
          "110".lowerDIFs = [ "normal.DIF" ];
        };
      };

      ipcps = mkOption {
        type = types.listOf (types.submodule {
          options = {
            apName = mkOption {
              type = types.str;
              description = ''
                Name of the application process.
              '';
            };

            type = mkOption {
              type = types.str;
              description = ''
                Type of DIF to create.
              '';
            };

            difName = mkOption {
              type = types.str;
              description = ''
                Name of the DIF to create.
              '';
            };

            params = mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = ''
                Configuration parameters for the IPC process.
              '';
            };

            registerAt = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "110" ];
              description = ''
                Names of DIFs to register this IPC process to.
              '';
            };

            enrollerEnable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Enable this IPC process to act as enroller for its DIF.
                This is needed for the first IPCP of a DIF, that does
                not enroll to another IPCP.
              '';
            };

            enrollments = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  difName = mkOption {
                    type = types.str;
                    description = ''
                      Name of the DIF to enroll the IPCP into.
                    '';
                  };

                  supportDIFName = mkOption {
                    type = types.str;
                    description = ''
                      Name of the DIF that supports this enrolment.
                    '';
                  };

                  neighbourIPCPName = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                      Name of the neighbour IPC process.
                    '';
                  };
                };
              });
              default = [];
              example = [
                { difName = "normal.DIF";
                  supportDIFName = "ethAB.DIF";
                  neighbourIPCPName = "normal.b.IPCP";
                }
              ];
              description = ''
                The enrollments of this IPC process.
              '';
            };
          };
        });
        default = [];
        example = [
          { apName = "ethAB.IPCP";
            type = "shim-eth";
            difName = "ethAB.DIF";
          }
          { apName = "b.IPCP";
            type = "normal";
            difName = "n.DIF";
          }
        ];
        description = ''
          The IPC processes to create.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rlite ];

    boot = {
      kernelModules = [
		    "rlite"
		    "rlite-normal"
		    "rlite-shim-eth"
      ];
      extraModulePackages = [ kernel.rlite ];
    };

    systemd.services = {
      rlite-uipcps = {
        description = "RINA userspace IPC processes daemon";

        before = [ "network.target" ];
        wantedBy = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.rlite}/bin/rlite-uipcps";
        };
      };

      rlite-setup-commands = {
        description = "Configuration commands for rlite-uipcps.";
        before = [ "network.target" ];
        wantedBy = [ "network.target" ];
        after = [ "network-local-commands.service" "rlite-uipcps.service" ];
        unitConfig.ConditionCapability = "CAP_NET_ADMIN";
        path = [ pkgs.rlite ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          set -xe

          # Configure rlite IPC processes.
          ${initScript}

          # Run any user-specified commands.
          ${cfg.initCommands}
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ rvl ];
}
