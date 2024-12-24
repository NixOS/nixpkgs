# Derivation containing the Limine host tool and the compiled bootloader
{
  fetchurl,
  lib,
  llvmPackages_18,
  mtools,
  nasm,
  # The following options map to configure flags.
  enableAll ? false,
  buildCDs ? false,
  targets ? [ ],
  # x86 specific flags
  biosSupport ? false,
  pxeSupport ? false,
}:

let
  llvmPackages = llvmPackages_18;
  stdenv = llvmPackages.stdenv;

  version = "8.6.0";

  hasI686 =
    (if targets == [ ] then stdenv.hostPlatform.isx86_32 else (builtins.elem "i686" targets))
    || enableAll;

  hasX86_64 =
    (if targets == [ ] then stdenv.hostPlatform.isx86_64 else (builtins.elem "x86_64" targets))
    || enableAll;

  uefiFlags =
    target:
    {
      aarch64 = [ "--enable-uefi-aarch64" ];
      i686 = [ "--enable-uefi-ia32" ];
      loongarch64 = [ "--enable-uefi-loongarch64" ];
      riscv64 = [ "--enable-uefi-riscv64" ];
      x86_64 = [ "--enable-uefi-x86-64" ];
    }
    .${target} or (throw "Unsupported target ${target}");

  configureFlags =
    lib.optionals enableAll [ "--enable-all" ]
    ++ lib.optionals biosSupport [ "--enable-bios" ]
    ++ lib.optionals (buildCDs && biosSupport) [ "--enable-bios-cd" ]
    ++ lib.optionals buildCDs [ "--enable-uefi-cd" ]
    ++ lib.optionals pxeSupport [ "--enable-bios-pxe" ]
    ++ lib.concatMap uefiFlags (
      if targets == [ ] then [ stdenv.hostPlatform.parsed.cpu.name ] else targets
    );
in

assert lib.assertMsg (!(biosSupport && !hasI686)) "BIOS builds are possible only for x86";

assert lib.assertMsg (!(pxeSupport && !hasI686)) "PXE builds are possible only for x86";

# The output of the derivation is a tool to create bootable images using Limine
# as bootloader for various platforms and corresponding binary and helper files.
stdenv.mkDerivation {
  inherit version configureFlags;
  pname = "limine";
  # We don't use the Git source but the release tarball, as the source has a
  # `./bootstrap` script performing network access to download resources.
  # Packaging that in Nix is very cumbersome.
  src = fetchurl {
    url = "https://github.com/limine-bootloader/limine/releases/download/v${version}/limine-${version}.tar.gz";
    hash = "sha256-4bFZ6nxNcrJTQhkJ5S1KU0PJN4yu9Li+QznF5IxpGCE=";
  };

  hardeningDisable = [
    # clang doesn't support this for RISC-V target
    "zerocallusedregs"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs =
    [
      llvmPackages.libllvm
      llvmPackages.lld
    ]
    ++ lib.optionals (enableAll || buildCDs) [
      mtools
    ]
    ++ lib.optionals (hasI686 || hasX86_64) [ nasm ];

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  meta = with lib; {
    homepage = "https://limine-bootloader.org/";
    description = "Limine Bootloader";
    mainProgram = "limine";
    # The platforms on that the Limine binary and helper tools can run, not
    # necessarily the platforms for that bootable images can be created.
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    # Caution. Some submodules have different licenses.
    license = [
      licenses.asl20 # cc-runtime
      licenses.bsd0 # freestanding-toolchain, freestanding-headers
      licenses.bsd2 # limine, flanterm
      licenses.mit # limine-efi, stb
      licenses.zlib # tinf
    ];
    maintainers = [
      maintainers._48cf
      maintainers.phip1611
      maintainers.sanana
      maintainers.surfaceflinger
    ];
  };
}
