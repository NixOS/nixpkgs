{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nbd;
  configFormat = pkgs.formats.ini { };
  iniFields = with types; attrsOf (oneOf [ bool int float str ]);
  serverConfig = configFormat.generate "nbd-server-config"
    ({
      generic =
        (cfg.server.extraOptions // {
          user = "root";
          group = "root";
          port = cfg.server.listenPort;
        } // (optionalAttrs (cfg.server.listenAddress != null) {
          listenaddr = cfg.server.listenAddress;
        }));
    }
    // (mapAttrs
      (_: { path, allowAddresses, extraOptions }:
        extraOptions // {
          exportname = path;
        } // (optionalAttrs (allowAddresses != null) {
          authfile = pkgs.writeText "authfile" (concatStringsSep "\n" allowAddresses);
        }))
      cfg.server.exports)
    );
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
          description = "Port to listen on. The port is NOT automatically opened in the firewall.";
        };

        extraOptions = mkOption {
          type = iniFields;
          default = {
            allowlist = false;
          };
          description = ''
            Extra options for the server. See
            <citerefentry><refentrytitle>nbd-server</refentrytitle>
            <manvolnum>5</manvolnum></citerefentry>.
          '';
        };

        exports = mkOption {
          description = "Files or block devices to make available over the network.";
          default = { };
          type = with types; attrsOf
            (submodule {
              options = {
                path = mkOption {
                  type = str;
                  description = "File or block device to export.";
                  example = "/dev/sdb1";
                };

                allowAddresses = mkOption {
                  type = nullOr (listOf str);
                  default = null;
                  example = [ "10.10.0.0/24" "127.0.0.1" ];
                  description = "IPs and subnets that are authorized to connect for this device. If not specified, the server will allow all connections.";
                };

                extraOptions = mkOption {
                  type = iniFields;
                  default = {
                    flush = true;
                    fua = true;
                  };
                  description = ''
                    Extra options for this export. See
                    <citerefentry><refentrytitle>nbd-server</refentrytitle>
                    <manvolnum>5</manvolnum></citerefentry>.
                  '';
                };
              };
            });
        };

        listenAddress = mkOption {
          type = with types; nullOr str;
          description = "Address to listen on. If not specified, the server will listen on all interfaces.";
          default = null;
          example = "10.10.0.1";
        };
      };
    };
  };

  config = mkIf cfg.server.enable {
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
