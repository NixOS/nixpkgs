{config, lib, ...}: let
  inherit (lib) types;
in {
  options.systemd.services = lib.mkOption {
    type = types.attrsOf (types.submodule ({
      name,
      config,
      ...
    }: {
      options.harden = {
        enable = lib.mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Basic restrictions for systemd services
          '';
        };

        execOnlyNix = lib.mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Mark whole system as non-executable with exception for `/nix/store`.
          '';
        };

        protectKernel = lib.mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Protect kernel internals from being reachable by the service.
          '';
        };

        proc = lib.mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Restrict view into `/proc` to only allow access for limited subset.
          '';
        };

        onlyLocalhost = lib.mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Allow listening sockets only on localhost.
          '';
        };

        ipSockets = lib.mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
          Allow using AF_INET and AF_INET6
          '';
        };
      };
      config.serviceConfig = let
        cfg = config.harden;
        inherit (lib) mkDefault;
      in
        lib.optionalAttrs cfg.enable ({
          NoNewPrivileges = mkDefault true;
          LockPersonality = mkDefault true;
          RemoveIPC = mkDefault true;

          MemoryDenyWriteExecute = mkDefault true;

          CapabilityBoundingSet = mkDefault [ "" ];

          RestrictNamespaces = mkDefault true;
          RestrictRealtime = mkDefault true;
          RestrictSUIDSGID = mkDefault true;

          ProtectHome = mkDefault true;
          ProtectClock = mkDefault true;
          ProtectControlGroups = mkDefault true;

          RestrictAddressFamilies = mkDefault (
            [ "AF_UNIX" ] ++ lib.optionals cfg.ipSockets [ "AF_INET" "AF_INET6" ]
          );

          PrivateDevices = mkDefault true;
          PrivateTmp = mkDefault true;
          PrivateMounts = mkDefault true;
          PrivateUsers = mkDefault true;

          # By default it does nothing as everything is allowed unless we use
          # `NoExecPaths`. So this is good default.
          ExecPaths = mkDefault [ "/nix/store" ];

          ProtectKernelLogs = cfg.protectKernel;
          ProtectKernelModules = cfg.protectKernel;
          ProtectKernelTunables = cfg.protectKernel;

          SystemCallFilter = mkDefault [ "@system-service" ];
          SystemCallArchitectures = [ "native" ];
          SystemCallErrorNumber = mkDefault "EPERM";
        }
        // (lib.optionalAttrs cfg.execOnlyNix {
          NoExecPaths = [ "/" ];
        })
        // (lib.optionalAttrs config.harden.proc {
          ProtectProc = mkDefault "invisible";
          ProcSubset = "pid";
        })
        // (lib.optionalAttrs config.harden.onlyLocalhost {
          IPAddressAllow = [ "localhost" ];
          IPAddressDeny = [ "any" ];
        }));
    }));
  };
}
