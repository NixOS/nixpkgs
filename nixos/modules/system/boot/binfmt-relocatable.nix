{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.boot.binfmt.relocatable;
  inherit (config.boot.kernelPackages) kernel;

  # bpf-backed binfmt_misc handlers arrived in this kernel release.
  minKernelVersion = "7.3";

  # Program header types reserved for operating system specific semantics.
  ptLoos = lib.fromHexString "60000000";
  ptHios = lib.fromHexString "6fffffff";

  # Struct_ops names compiled into the objects of the binfmt-origin package.
  elfHandler = "elf_origin";
  scriptHandler = "script_origin";
in
{
  options.boot.binfmt.relocatable = {
    enable = mkEnableOption ''
      relocatable executables, whose ELF loader or `#!` interpreter is named
      relative to the executable's own directory with `$ORIGIN`. This
      registers BPF binfmt_misc handlers and requires Linux 7.3 or newer'';

    elf.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to run ELF64 binaries whose loader is given as
        `$ORIGIN/...`, either in `PT_INTERP` itself or in a program header
        of type {option}`boot.binfmt.relocatable.ptInterpOriginType`. The
        latter keeps an absolute `PT_INTERP` so the binary also runs where
        this handler is not loaded. The binary runs as a native exec with
        the resolved loader substituted.
      '';
    };

    scripts.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to run scripts whose interpreter is given as `#!$ORIGIN/...`,
        either on line 1, or on line 2 after an ordinary absolute `#!` line
        on line 1 (optionally behind one comment token such as `--`). The
        line 2 form keeps the script runnable where this handler is not
        loaded.
      '';
    };

    ptInterpOriginType = mkOption {
      type = types.ints.between ptLoos ptHios;
      default = lib.fromHexString "6f726967";
      defaultText = lib.literalExpression ''lib.fromHexString "6f726967"'';
      description = ''
        Program header type (`p_type`) of the segment that holds a
        relocatable `$ORIGIN/...` loader path next to an absolute
        `PT_INTERP`. No toolchain defines this type yet, so it is chosen
        from the OS-specific range `PT_LOOS`..`PT_HIOS`. The default spells
        "orig" in ASCII.
      '';
    };

    package = mkOption {
      type = types.package;
      default =
        let
          pkg = config.boot.kernelPackages.binfmt-origin or null;
        in
        if pkg == null then
          throw "boot.binfmt.relocatable requires Linux ${minKernelVersion} or newer"
        else
          pkg.override { inherit (cfg) ptInterpOriginType; };
      defaultText = lib.literalExpression ''
        config.boot.kernelPackages.binfmt-origin.override {
          inherit (config.boot.binfmt.relocatable) ptInterpOriginType;
        }
      '';
      description = ''
        Package providing `lib/bpf/elf_origin.bpf.o` and
        `lib/bpf/script_origin.bpf.o`, built against the BTF of the running
        kernel.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = lib.versionAtLeast kernel.version minKernelVersion;
          message = "boot.binfmt.relocatable requires Linux ${minKernelVersion} or newer, but boot.kernelPackages is ${kernel.version}.";
        }
      ];

      # Checked against the kernel's actual .config when the system is built.
      system.requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "BINFMT_MISC")
        (isYes "BINFMT_MISC_BPF")
      ];
    }

    (mkIf cfg.elf.enable {
      boot.binfmt.bpfHandlers.${elfHandler}.object = "${cfg.package}/lib/bpf/${elfHandler}.bpf.o";
      boot.binfmt.registrations.elf-origin = {
        recognitionType = "bpf";
        bpfHandler = elfHandler;
      };
    })

    (mkIf cfg.scripts.enable {
      boot.binfmt.bpfHandlers.${scriptHandler}.object = "${cfg.package}/lib/bpf/${scriptHandler}.bpf.o";
      boot.binfmt.registrations.script-origin = {
        recognitionType = "bpf";
        bpfHandler = scriptHandler;
      };
    })
  ]);

  meta.maintainers = with lib.maintainers; [ fzakaria ];
}
