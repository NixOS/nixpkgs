{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.wyoming.piper;

  inherit (lib)
    escapeShellArgs
    mkOption
    mkEnableOption
    mkPackageOption
    types
    ;

  inherit (builtins)
    toString
    ;

in

{
  meta.buildDocsInSandbox = false;

  options.services.wyoming.piper = with types; {
    package = mkPackageOption pkgs "wyoming-piper" { };

    servers = mkOption {
      default = {};
      description = ''
        Attribute set of piper instances to spawn.
      '';
      type = types.attrsOf (types.submodule (
        { ... }: {
          options = {
            enable = mkEnableOption "Wyoming Piper server";

            piper = mkPackageOption pkgs "piper-tts" { };

            voice = mkOption {
              type = str;
              example = "en-us-ryan-medium";
              description = ''
                Name of the voice model to use. See the following website for samples:
                https://rhasspy.github.io/piper-samples/
              '';
            };

            uri = mkOption {
              type = strMatching "^(tcp|unix)://.*$";
              example = "tcp://0.0.0.0:10200";
              description = ''
                URI to bind the wyoming server to.
              '';
            };

            speaker = mkOption {
              type = ints.unsigned;
              default = 0;
              description = ''
                ID of a specific speaker in a multi-speaker model.
              '';
              apply = toString;
            };

            noiseScale = mkOption {
              type = float;
              default = 0.667;
              description = ''
                Generator noise value.
              '';
              apply = toString;
            };

            noiseWidth = mkOption {
              type = float;
              default = 0.333;
              description = ''
                Phoneme width noise value.
              '';
              apply = toString;
            };

            lengthScale = mkOption {
              type = float;
              default = 1.0;
              description = ''
                Phoneme length value.
              '';
              apply = toString;
            };

            extraArgs = mkOption {
              type = listOf str;
              default = [ ];
              description = ''
                Extra arguments to pass to the server commandline.
              '';
              apply = escapeShellArgs;
            };
          };
        }
      ));
    };
  };

  config = let
    inherit (lib)
      mapAttrs'
      mkIf
      nameValuePair
    ;
  in mkIf (cfg.servers != {}) {
    systemd.services = mapAttrs' (server: options:
      nameValuePair "wyoming-piper-${server}" {
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
      }) cfg.servers;
  };
}
