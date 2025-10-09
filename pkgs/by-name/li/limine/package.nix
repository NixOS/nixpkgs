# Derivation containing the Limine host tool and the compiled bootloader
{
  fetchurl,
  lib,
  llvmPackages,
  mtools,
  nasm,
  nixosTests,
  # The following options map to configure flags.
  enableAll ? false,
  buildCDs ? false,
  targets ? [ ],
  # x86 specific flags
  biosSupport ? true,
  pxeSupport ? false,
}:

let
  stdenv = llvmPackages.stdenv;

  hasX86 =
    (if targets == [ ] then stdenv.hostPlatform.isx86_32 else (builtins.elem "i686" targets))
    || (if targets == [ ] then stdenv.hostPlatform.isx86_64 else (builtins.elem "x86_64" targets))
    || enableAll;

  biosSupport' = biosSupport && hasX86;
  pxeSupport' = pxeSupport && hasX86;

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
in

# The output of the derivation is a tool to create bootable images using Limine
# as bootloader for various platforms and corresponding binary and helper files.
stdenv.mkDerivation (finalAttrs: {
  pname = "limine";
  version = "10.1.0";

  # We don't use the Git source but the release tarball, as the source has a
  # `./bootstrap` script performing network access to download resources.
  # Packaging that in Nix is very cumbersome.
  src = fetchurl {
    url = "https://codeberg.org/Limine/Limine/releases/download/v${finalAttrs.version}/limine-${finalAttrs.version}.tar.gz";
    hash = "sha256-Hn1njCaHcdCocnKpAZhkcMXG6tAojVQQtVAW4pVUFGI=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    llvmPackages.libllvm
    llvmPackages.lld
  ]
  ++ lib.optionals (enableAll || buildCDs) [
    mtools
  ]
  ++ lib.optionals hasX86 [ nasm ];

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  configureFlags =
    lib.optionals enableAll [ "--enable-all" ]
    ++ lib.optionals biosSupport' [ "--enable-bios" ]
    ++ lib.optionals (buildCDs && biosSupport') [ "--enable-bios-cd" ]
    ++ lib.optionals buildCDs [ "--enable-uefi-cd" ]
    ++ lib.optionals pxeSupport' [ "--enable-bios-pxe" ]
    ++ lib.concatMap uefiFlags (
      if targets == [ ] then [ stdenv.hostPlatform.parsed.cpu.name ] else targets
    );

  passthru.tests = nixosTests.limine;

  meta = {
    homepage = "https://limine-bootloader.org/";
    changelog = "https://codeberg.org/Limine/Limine/raw/tag/v${finalAttrs.version}/ChangeLog";
    description = "Limine Bootloader";
    mainProgram = "limine";
    # The platforms on that the Limine binary and helper tools can run, not
    # necessarily the platforms for that bootable images can be created.
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    # Caution. Some submodules have different licenses.
    license = with lib.licenses; [
      asl20 # cc-runtime
      bsd0 # freestanding-headers, freestanding-toolchain
      bsd2 # limine, flanterm, libfdt, PicoEFI
      bsd2Patent # PicoEFI
      bsd3 # PicoEFI
      bsdAxisNoDisclaimerUnmodified # PicoEFI
      mit # PicoEFI, stb_image
      zlib # tinf
    ];
    maintainers = with lib.maintainers; [
      johnrtitor
      lzcunt
      phip1611
      prince213
      programmerlexi
      surfaceflinger
    ];
  };
})
