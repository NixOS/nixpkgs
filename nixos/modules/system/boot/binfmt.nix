{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkDefault
    types
    optionalString
    ;

  cfg = config.boot.binfmt;

  makeBinfmtLine =
    name:
    {
      recognitionType,
      offset,
      magicOrExtension,
      mask,
      preserveArgvZero,
      openBinary,
      matchCredentials,
      fixBinary,
      ...
    }:
    let
      type = if recognitionType == "magic" then "M" else "E";
      offset' = toString offset;
      mask' = toString mask;
      interpreter = "/run/binfmt/${name}";
      flags =
        if !(matchCredentials -> openBinary) then
          throw "boot.binfmt.registrations.${name}: you can't specify openBinary = false when matchCredentials = true."
        else
          optionalString preserveArgvZero "P"
          + optionalString (openBinary && !matchCredentials) "O"
          + optionalString matchCredentials "C"
          + optionalString fixBinary "F";
    in
    ":${name}:${type}:${offset'}:${magicOrExtension}:${mask'}:${interpreter}:${flags}";

  mkInterpreter =
    name:
    { interpreter, wrapInterpreterInShell, ... }:
    if wrapInterpreterInShell then
      pkgs.writeShellScript "${name}-interpreter" ''
        #!${pkgs.bash}/bin/sh
        exec -- ${interpreter} "$@"
      ''
    else
      interpreter;

  # Mapping of systems to “magicOrExtension” and “mask”. Mostly taken from:
  # - https://github.com/cleverca22/nixos-configs/blob/master/qemu.nix
  # and
  # - https://github.com/qemu/qemu/blob/master/scripts/qemu-binfmt-conf.sh
  # TODO: maybe put these in a JSON file?
  magics = {
    armv6l-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
    };
    armv7l-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
    };
    aarch64-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
    };
    aarch64_be-linux = {
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    i386-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    i486-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    i586-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    i686-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    x86_64-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    alpha-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x26\x90'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    sparc64-linux = {
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x02'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    sparc-linux = {
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x12'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    powerpc-linux = {
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    powerpc64-linux = {
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    powerpc64le-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\x00'';
    };
    mips-linux = {
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20'';
    };
    mipsel-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00'';
    };
    mips64-linux = {
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    mips64el-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    mips64-linuxabin32 = {
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20'';
    };
    mips64el-linuxabin32 = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\x00\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00'';
    };
    riscv32-linux = {
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    riscv64-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    loongarch64-linux = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x02\x01'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\xfc\x00\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    wasm32-wasi = {
      magicOrExtension = ''\x00asm'';
      mask = ''\xff\xff\xff\xff'';
    };
    wasm64-wasi = {
      magicOrExtension = ''\x00asm'';
      mask = ''\xff\xff\xff\xff'';
    };
    s390x-linux = {
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x16'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    x86_64-windows.magicOrExtension = "MZ";
    i686-windows.magicOrExtension = "MZ";
  };

in
{
  imports = [
    (lib.mkRenamedOptionModule [ "boot" "binfmtMiscRegistrations" ] [ "boot" "binfmt" "registrations" ])
  ];

  options = {
    boot.binfmt = {
      registrations = mkOption {
        default = { };

        description = ''
          Extra binary formats to register with the kernel.
          See https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html for more details.
        '';

        type = types.attrsOf (
          types.submodule (
            { config, ... }:
            {
              options = {
                recognitionType = mkOption {
                  default = "magic";
                  description = "Whether to recognize executables by magic number or extension.";
                  type = types.enum [
                    "magic"
                    "extension"
                  ];
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
                  description = "A mask to be ANDed with the byte sequence of the file before matching";
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

                wrapInterpreterInShell = mkOption {
                  default = true;
                  description = ''
                    Whether to wrap the interpreter in a shell script.

                    This allows a shell command to be set as the interpreter.
                  '';
                  type = types.bool;
                };

                interpreterSandboxPath = mkOption {
                  internal = true;
                  default = null;
                  description = ''
                    Path of the interpreter to expose in the build sandbox.
                  '';
                  type = types.nullOr types.path;
                };
              };
            }
          )
        );
      };

      emulatedSystems = mkOption {
        default = [ ];
        example = [
          "wasm32-wasi"
          "x86_64-windows"
          "aarch64-linux"
        ];
        description = ''
          List of systems to emulate. Will also configure Nix to
          support your new systems.
          Warning: the builder can execute all emulated systems within the same build, which introduces impurities in the case of cross compilation.
        '';
        type = types.listOf (types.enum (builtins.attrNames magics));
      };

      addEmulatedSystemsToNixSandbox = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to add the {option}`boot.binfmt.emulatedSystems` to {option}`nix.settings.extra-platforms`.
          Disable this to use remote builders for those platforms, while allowing testing binaries locally.
        '';
      };

      preferStaticEmulators = mkOption {
        default = false;
        description = ''
          Whether to use static emulators when available.

          This enables the kernel to preload the emulator binaries when
          the binfmt registrations are added, obviating the need to make
          the emulator binaries available inside chroots and chroot-like
          sandboxes.
        '';
        type = types.bool;
      };
    };
  };

  config = {
    assertions = lib.mapAttrsToList (name: reg: {
      assertion = reg.fixBinary -> !reg.wrapInterpreterInShell;
      message = "boot.binfmt.registrations.\"${name}\" cannot have fixBinary when the interpreter is invoked through a shell.";
    }) cfg.registrations;

    boot.binfmt.registrations = builtins.listToAttrs (
      map (
        system:
        assert system != pkgs.stdenv.hostPlatform.system;
        {
          name = system;
          value =
            { config, ... }:
            let
              elaborated = lib.systems.elaborate { inherit system; };
              useStaticEmulator = cfg.preferStaticEmulators && elaborated.staticEmulatorAvailable pkgs;
              interpreter = elaborated.emulator (if useStaticEmulator then pkgs.pkgsStatic else pkgs);

              inherit (elaborated) qemuArch;
              isQemu = "qemu-${qemuArch}" == baseNameOf interpreter;

              interpreterReg =
                let
                  wrapperName = "qemu-${qemuArch}-binfmt-P";
                  wrapper = pkgs.wrapQemuBinfmtP wrapperName interpreter;
                in
                if isQemu && !useStaticEmulator then "${wrapper}/bin/${wrapperName}" else interpreter;
            in
            (
              {
                preserveArgvZero = mkDefault isQemu;

                interpreter = mkDefault interpreterReg;
                fixBinary = mkDefault useStaticEmulator;
                wrapInterpreterInShell = mkDefault (!config.preserveArgvZero && !config.fixBinary);
                interpreterSandboxPath = mkDefault (dirOf (dirOf config.interpreter));
              }
              // (magics.${system} or (throw "Cannot create binfmt registration for system ${system}"))
            );
        }
      ) cfg.emulatedSystems
    );
    nix.settings = lib.mkIf (cfg.addEmulatedSystemsToNixSandbox && cfg.emulatedSystems != [ ]) {
      extra-platforms =
        cfg.emulatedSystems
        ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 "i686-linux";
      extra-sandbox-paths =
        let
          ruleFor = system: cfg.registrations.${system};
          hasWrappedRule = lib.any (system: (ruleFor system).wrapInterpreterInShell) cfg.emulatedSystems;
        in
        [ "/run/binfmt" ]
        ++ lib.optional hasWrappedRule "${pkgs.bash}"
        ++ (map (system: (ruleFor system).interpreterSandboxPath) cfg.emulatedSystems);
    };

    environment.etc."binfmt.d/nixos.conf".source = builtins.toFile "binfmt_nixos.conf" (
      lib.concatStringsSep "\n" (lib.mapAttrsToList makeBinfmtLine config.boot.binfmt.registrations)
    );

    systemd = lib.mkMerge [
      ({
        tmpfiles.rules =
          [
            "d /run/binfmt 0755 -"
          ]
          ++ lib.mapAttrsToList (name: interpreter: "L+ /run/binfmt/${name} - - - - ${interpreter}") (
            lib.mapAttrs mkInterpreter config.boot.binfmt.registrations
          );
      })

      (lib.mkIf (config.boot.binfmt.registrations != { }) {
        additionalUpstreamSystemUnits = [
          "proc-sys-fs-binfmt_misc.automount"
          "proc-sys-fs-binfmt_misc.mount"
          "systemd-binfmt.service"
        ];
        services.systemd-binfmt.after = [ "systemd-tmpfiles-setup.service" ];
        services.systemd-binfmt.restartTriggers = [ (builtins.toJSON config.boot.binfmt.registrations) ];
      })
    ];
  };
}
