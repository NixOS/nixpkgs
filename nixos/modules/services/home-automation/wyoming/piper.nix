{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wyoming.piper;

  inherit (builtins)
    toString
    ;

in

{
  meta.buildDocsInSandbox = false;

  options.services.wyoming.piper = {
    package = lib.mkPackageOption pkgs "wyoming-piper" { };

    servers = lib.mkOption {
      default = { };
      description = ''
        Attribute set of piper instances to spawn.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              enable = lib.mkEnableOption "Wyoming Piper server";

              piper = lib.mkPackageOption pkgs "piper-tts" { };

              voice = lib.mkOption {
                type = lib.types.str;
                example = "en-us-ryan-medium";
                description = ''
                  Name of the voice model to use. See the following website for samples:
                  https://rhasspy.github.io/piper-samples/
                '';
              };

              uri = lib.mkOption {
                type = lib.types.strMatching "^(tcp|unix)://.*$";
                example = "tcp://0.0.0.0:10200";
                description = ''
                  URI to bind the wyoming server to.
                '';
              };

              speaker = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 0;
                description = ''
                  ID of a specific speaker in a multi-speaker model.
                '';
                apply = toString;
              };

              noiseScale = lib.mkOption {
                type = lib.types.float;
                default = 0.667;
                description = ''
                  Generator noise value.
                '';
                apply = toString;
              };

              noiseWidth = lib.mkOption {
                type = lib.types.float;
                default = 0.333;
                description = ''
                  Phoneme width noise value.
                '';
                apply = toString;
              };

              lengthScale = lib.mkOption {
                type = lib.types.float;
                default = 1.0;
                description = ''
                  Phoneme length value.
                '';
                apply = toString;
              };

              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  Extra arguments to pass to the server commandline.
                '';
                apply = lib.escapeShellArgs;
              };
            };
          }
        )
      );
    };
  };

  config =
    lib.mkIf (cfg.servers != { }) {
      systemd.services = lib.mapAttrs' (
        server: options:
        lib.nameValuePair "wyoming-piper-${server}" {
          inherit (options) enable;
          description = "Wyoming Piper server instance ${server}";
          wants = [
            "network-online.target"
          ];
          after = [
            "network-online.target"
          ];
          wantedBy = [
            "multi-user.target"
          ];
          serviceConfig = {
            DynamicUser = true;
            User = "wyoming-piper";
            StateDirectory = "wyoming/piper";
            # https://github.com/home-assistant/addons/blob/master/piper/rootfs/etc/s6-overlay/s6-rc.d/piper/run
            ExecStart = ''
              ${cfg.package}/bin/wyoming-piper \
                --data-dir $STATE_DIRECTORY \
                --download-dir $STATE_DIRECTORY \
                --uri ${options.uri} \
                --piper ${options.piper}/bin/piper \
                --voice ${options.voice} \
                --speaker ${options.speaker} \
                --length-scale ${options.lengthScale} \
                --noise-scale ${options.noiseScale} \
                --noise-w ${options.noiseWidth} ${options.extraArgs}
            '';
            CapabilityBoundingSet = "";
            DeviceAllow = "";
            DevicePolicy = "closed";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";
            ProcSubset = "pid";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            UMask = "0077";
          };
        }
      ) cfg.servers;
    };
}
