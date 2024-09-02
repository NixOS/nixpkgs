# Builds limine with all available features.

{
  # Helpers
  stdenv
, fetchurl
, lib
, # Dependencies
  llvmPackages
, mtools
, nasm
  # Optional features
, enableAllTargets ? true
, x86Support ? enableAllTargets || stdenv.targetPlatform.isx86
, x86BiosSupport ? enableAllTargets || x86Support
, x86BiosCdSupport ? enableAllTargets || x86BiosSupport
, x86BiosPxeSupport ? enableAllTargets || x86BiosSupport
, x86UefiSupport ? enableAllTargets || x86Support
, x86_32UefiSupport ? enableAllTargets || x86UefiSupport
, x86_64UefiSupport ? enableAllTargets || x86UefiSupport
, aarch64UefiSupport ? enableAllTargets || stdenv.targetPlatform.isAarch64
, riscv64UefiSupport ? enableAllTargets || stdenv.targetPlatform.isRiscV64
, loongArch64UefiSupport ? enableAllTargets || stdenv.targetPlatform.isLoongArch64
, uefiCdSupport ? enableAllTargets
}:

let
  version = "8.0.9";
in
# The output of the derivation is a tool to create bootable images using Limine
# as bootloader for various platforms and corresponding binary and helper files.
stdenv.mkDerivation {
  inherit version;
  pname = "limine";
  # We don't use the Git source but the release tarball, as the source has a
  # `./bootstrap` script performing network access to download resources.
  # Packaging that in Nix is very cumbersome.
  src = fetchurl {
    url = "https://github.com/limine-bootloader/limine/releases/download/v${version}/limine-${version}.tar.gz";
    sha256 = "sha256-1UC/vrlPZyxcwWNlYU0+xby7VfX+dhpSSKtRZyA6tdU=";
  };

  hardeningDisable = [
    # clang for riscv does not support this
    "zerocallusedregs"
  ];

  nativeBuildInputs = [
    llvmPackages.bintools
    # gcc is used for the host tool, while clang is used for the bootloader.
    llvmPackages.clang
    llvmPackages.lld
  ] ++
    lib.optional x86Support nasm ++
    lib.optional uefiCdSupport mtools;

  configureFlags = [
    (lib.enableFeature x86BiosCdSupport "bios-cd")
    (lib.enableFeature x86BiosPxeSupport "bios-pxe")
    (lib.enableFeature x86BiosSupport "bios")
    (lib.enableFeature x86_32UefiSupport "uefi-ia32")
    (lib.enableFeature x86_64UefiSupport "uefi-x86_64")
    (lib.enableFeature aarch64UefiSupport "uefi-aarch64")
    (lib.enableFeature riscv64UefiSupport "uefi-riscv64")
    (lib.enableFeature loongArch64UefiSupport "uefi-loongarch64")
    (lib.enableFeature uefiCdSupport "uefi-cd")
  ];

  installFlags = [ "destdir=$out" "manprefix=/share" ];

  outputs = [ "out" "doc" "dev" "man" ];

  meta = with lib; {
    homepage = "https://limine-bootloader.org/";
    description = "Limine Bootloader";
    # Caution. Some submodules have different licenses.
    license = [
      licenses.bsd2 # limine, flanterm
      licenses.bsd0 # freestanding-toolchain, freestanding-headers
      licenses.asl20 # cc-runtime
      licenses.mit # limine-efi, stb
      licenses.zlib # tinf
    ];
    # The platforms on that the Limine binary and helper tools can run, not
    # necessarily the platforms for that bootable images can be created.
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    maintainers = [
      maintainers._48cf
      maintainers.phip1611
    ];
  };
}
