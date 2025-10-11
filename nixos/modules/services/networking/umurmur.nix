{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.umurmur;
  dumpAttrset =
    x: top_level:
    (lib.optionalString (!top_level) "{")
    + (lib.concatLines (lib.mapAttrsToList (name: value: "${name} = ${toConfigValue value false};") x))
    + (lib.optionalString (!top_level) "}");
  dumpList = x: top_level: "(${lib.concatStringsSep ",\n" (map (y: "${toConfigValue y false}") x)})";

  toConfigValue =
    x: top_level:
    if builtins.isList x then
      dumpList x top_level
    else if builtins.isAttrs x then
      dumpAttrset x top_level
    else
      builtins.toJSON x;
  dumpCfg = x: toConfigValue x true;
  configAttrs = lib.filterAttrsRecursive (name: value: value != null) cfg.settings;
  configFile = pkgs.writeTextFile {
    name = "umurmur.conf";
    checkPhase = ''
      ${lib.getExe cfg.package} -t -c "$target"
    '';
    text = "\n" + (dumpCfg configAttrs) + "\n";
  };
in
{
  options = {
    services.umurmur = {
      enable = lib.mkEnableOption "uMurmur Mumble server";

      package = lib.mkPackageOption pkgs "umurmur" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the uMurmur Mumble server.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType =
            let
              valueType =
                with lib.types;
                (attrsOf (oneOf [
                  bool
                  int
                  float
                  str
                  path
                  (listOf valueType)
                ]))
                // {
                  description = "uMurmur config value";
                };
            in
            valueType;
          options = {
            welcometext = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "Welcome to uMurmur!";
              description = "Welcome message for connected clients.";
            };

            bindaddr = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = "IPv4 address to bind to. Defaults binding on all addresses.";
            };

            bindaddr6 = lib.mkOption {
              type = lib.types.str;
              default = "::";
              description = "IPv6 address to bind to. Defaults binding on all addresses.";
            };

            bindport = lib.mkOption {
              type = lib.types.port;
              default = 64739;
              description = "Port to bind to (UDP and TCP).";
            };

            password = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Required password to join server, if specified.";
            };

            max_bandwidth = lib.mkOption {
              type = lib.types.int;
              default = 48000;
              description = ''
                Maximum bandwidth (in bits per second) that clients may send
                speech at.
              '';
            };

            max_users = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Maximum number of concurrent clients allowed.";
            };

            certificate = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/private/umurmur/cert.crt";
              description = "Path to your SSL certificate. Generates self-signed automatically if not exists.";
            };

            private_key = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/private/umurmur/key.key";
              description = "Path to your SSL key. Generates self-signed automatically if not exists.";
            };

            ca_path = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = "Path to your SSL CA certificate.";
            };

            channels = lib.mkOption {
              type = lib.types.listOf lib.types.attrs;
              default = [
                {
                  name = "root";
                  parent = "";
                  description = "Root channel.";
                  noenter = false;
                }
              ];
              description = "Channel tree definitions.";
            };

            channel_links = lib.mkOption {
              type = lib.types.listOf lib.types.attrs;
              default = [ ];
              example = [
                {
                  source = "Lobby";
                  destination = "Red team";
                }
              ];
              description = "Channel tree definitions.";
            };

            default_channel = lib.mkOption {
              type = lib.types.str;
              default = "root";
              description = "The channel in which users will appear in when connecting.";
            };

          };
        };
        default = { };
        description = "Settings of uMurmur. For reference see <https://github.com/umurmur/umurmur/blob/master/umurmur.conf.example>";
      };

      configFile = lib.mkOption rec {
        type = lib.types.path;
        default = configFile;
        description = "Configuration file, default is generated from config.service.umurmur.settings";
        defaultText = description;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.bindport ];
      allowedUDPPorts = [ cfg.settings.bindport ];
    };

    systemd.services.umurmur = {
      description = "uMurmur Mumble Server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} -d -c ${cfg.configFile}";
        Restart = "on-failure";
        DynamicUser = true;
        StateDirectory = "umurmur";
        ReadWritePaths = "/dev/shm";

        # hardening
        UMask = 27;
        MemoryDenyWriteExecute = true;
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectSystem = "full";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@debug"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@resources"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
  meta.doc = ./umurmur.md;
}
