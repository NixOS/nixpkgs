{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types optionalString;

  cfg = config.boot.binfmt;

  makeBinfmtLine = name: { recognitionType, offset, magicOrExtension
                         , mask, preserveArgvZero, openBinary
                         , matchCredentials, fixBinary, ...
                         }: let
    type = if recognitionType == "magic" then "M" else "E";
    offset' = toString offset;
    mask' = toString mask;
    interpreter = "/run/binfmt/${name}";
    flags = if !(matchCredentials -> openBinary)
              then throw "boot.binfmt.registrations.${name}: you can't specify openBinary = false when matchCredentials = true."
            else optionalString preserveArgvZero "P" +
                 optionalString (openBinary && !matchCredentials) "O" +
                 optionalString matchCredentials "C" +
                 optionalString fixBinary "F";
  in ":${name}:${type}:${offset'}:${magicOrExtension}:${mask'}:${interpreter}:${flags}";

  activationSnippet = name: { interpreter, ... }:
    "ln -sf ${interpreter} /run/binfmt/${name}";

  getEmulator = system: (lib.systems.elaborate { inherit system; }).emulator pkgs;

in {
  options = {
    boot.binfmt = {
      registrations = mkOption {
        default = {};

        description = ''
          Extra binary formats to register with the kernel.
          See https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html for more details.
        '';

        type = types.attrsOf (types.submodule ({ config, ... }: {
          options = {
            recognitionType = mkOption {
              default = "magic";
              description = "Whether to recognize executables by magic number or extension.";
              type = types.enum [ "magic" "extension" ];
            };

            offset = mkOption {
              default = null;
              description = "The byte offset of the magic number used for recognition.";
              type = types.nullOr types.int;
            };

            magicOrExtension = mkOption {
              description = "The magic number or extension to match on.";
              type = types.str;
            };

            mask = mkOption {
              default = null;
              description =
                "A mask to be ANDed with the byte sequence of the file before matching";
              type = types.nullOr types.str;
            };

            interpreter = mkOption {
              description = ''
                The interpreter to invoke to run the program.

                Note that the actual registration will point to
                /run/binfmt/''${name}, so the kernel interpreter length
                limit doesn't apply.
              '';
              type = types.path;
            };

            preserveArgvZero = mkOption {
              default = false;
              description = ''
                Whether to pass the original argv[0] to the interpreter.

                See the description of the 'P' flag in the kernel docs
                for more details;
              '';
              type = types.bool;
            };

            openBinary = mkOption {
              default = config.matchCredentials;
              description = ''
                Whether to pass the binary to the interpreter as an open
                file descriptor, instead of a path.
              '';
              type = types.bool;
            };

            matchCredentials = mkOption {
              default = false;
              description = ''
                Whether to launch with the credentials and security
                token of the binary, not the interpreter (e.g. setuid
                bit).

                See the description of the 'C' flag in the kernel docs
                for more details.

                Implies/requires openBinary = true.
              '';
              type = types.bool;
            };

            fixBinary = mkOption {
              default = false;
              description = ''
                Whether to open the interpreter file as soon as the
                registration is loaded, rather than waiting for a
                relevant file to be invoked.

                See the description of the 'F' flag in the kernel docs
                for more details.
              '';
              type = types.bool;
            };
          };
        }));
      };

      emulatedSystems = mkOption {
        default = [];
        description = ''
          List of systems to emulate. Will also configure Nix to
          support your new systems.
        '';
        type = types.listOf types.string;
      };
    };
  };

  config = {
    boot.binfmt.registrations = builtins.listToAttrs (map (system: {
      name = system;
      value = {
        interpreter = getEmulator system;
      } // ({
        armv7l-linux = {
          magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
          mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
        };
        aarch64-linux = {
          magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
          mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
        };
        riscv64-linux = {
          magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00'';
          mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
        };
        x86_64-windows = {
          magicOrExtension = ".exe";
          recognitionType = "extension";
        };
        i686-windows = {
          magicOrExtension = ".exe";
          recognitionType = "extension";
        };
      }.${system} or (throw "Cannot create binfmt registration for system ${system}"));
    }) cfg.emulatedSystems);
    # TODO: add a nix.extraPlatforms option to NixOS!
    nix.extraOptions = lib.mkIf (cfg.emulatedSystems != []) ''
      extra-platforms = ${toString (cfg.emulatedSystems ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 "i686-linux")}
    '';
    # nix.sandboxPaths = lib.mkIf (cfg.emulatedSystems != []) ([ "/run/binfmt" ] ++ (map getEmulator cfg.emulatedSystems));

    environment.etc."binfmt.d/nixos.conf".source = builtins.toFile "binfmt_nixos.conf"
      (lib.concatStringsSep "\n" (lib.mapAttrsToList makeBinfmtLine cfg.registrations));
    system.activationScripts.binfmt = lib.mkIf (cfg.registrations != {}) ''
      mkdir -p -m 0755 /run/binfmt
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList activationSnippet cfg.registrations)}
    '';
    systemd.additionalUpstreamSystemUnits = lib.mkIf (cfg.registrations != {})
      [ "proc-sys-fs-binfmt_misc.automount"
        "proc-sys-fs-binfmt_misc.mount"
      ];
  };
}
