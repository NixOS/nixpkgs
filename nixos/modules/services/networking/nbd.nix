{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nbd;
  iniFields = with types; attrsOf (oneOf [ bool int float str ]);
  # The `[generic]` section must come before all the others in the
  # config file.  This means we can't just dump an attrset to INI
  # because that sorts the sections by name.  Instead, we serialize it
  # on its own first.
  genericSection = {
    generic = (cfg.server.extraOptions // {
      user = "root";
      group = "root";
      port = cfg.server.listenPort;
    } // (optionalAttrs (cfg.server.listenAddress != null) {
      listenaddr = cfg.server.listenAddress;
    }));
  };
  exportSections =
    mapAttrs
      (_: { path, allowAddresses, extraOptions }:
        extraOptions // {
          exportname = path;
        } // (optionalAttrs (allowAddresses != null) {
          authfile = pkgs.writeText "authfile" (concatStringsSep "\n" allowAddresses);
        }))
      cfg.server.exports;
  serverConfig =
    pkgs.writeText "nbd-server-config" ''
      ${lib.generators.toINI {} genericSection}
      ${lib.generators.toINI {} exportSections}
    '';
  splitLists =
    partition
      (path: hasPrefix "/dev/" path)
      (mapAttrsToList (_: { path, ... }: path) cfg.server.exports);
  allowedDevices = splitLists.right;
  boundPaths = splitLists.wrong;
in
{
  options = {
    services.nbd = {
      server = {
        enable = mkEnableOption "the Network Block Device (nbd) server";

        listenPort = mkOption {
          type = types.port;
          default = 10809;
          description = lib.mdDoc "Port to listen on. The port is NOT automatically opened in the firewall.";
        };

        extraOptions = mkOption {
          type = iniFields;
          default = {
            allowlist = false;
          };
          description = lib.mdDoc ''
            Extra options for the server. See
            {manpage}`nbd-server(5)`.
          '';
        };

        exports = mkOption {
          description = lib.mdDoc "Files or block devices to make available over the network.";
          default = { };
          type = with types; attrsOf
            (submodule {
              options = {
                path = mkOption {
                  type = str;
                  description = lib.mdDoc "File or block device to export.";
                  example = "/dev/sdb1";
                };

                allowAddresses = mkOption {
                  type = nullOr (listOf str);
                  default = null;
                  example = [ "10.10.0.0/24" "127.0.0.1" ];
                  description = lib.mdDoc "IPs and subnets that are authorized to connect for this device. If not specified, the server will allow all connections.";
                };

                extraOptions = mkOption {
                  type = iniFields;
                  default = {
                    flush = true;
                    fua = true;
                  };
                  description = lib.mdDoc ''
                    Extra options for this export. See
                    {manpage}`nbd-server(5)`.
                  '';
                };
              };
            });
        };

        listenAddress = mkOption {
          type = with types; nullOr str;
          description = lib.mdDoc "Address to listen on. If not specified, the server will listen on all interfaces.";
          default = null;
          example = "10.10.0.1";
        };
      };
    };
  };

  config = mkIf cfg.server.enable {
    assertions = [
      {
        assertion = !(cfg.server.exports ? "generic");
        message = "services.nbd.server exports must not be named 'generic'";
      }
    ];

    boot.kernelModules = [ "nbd" ];

    systemd.services.nbd-server = {
      after = [ "network-online.target" ];
      before = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nbd}/bin/nbd-server -C ${serverConfig}";
        Type = "forking";

        DeviceAllow = map (path: "${path} rw") allowedDevices;
        BindPaths = boundPaths;

        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "strict";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0077";
      };
    };
  };
}
