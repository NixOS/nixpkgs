# Derivation containing the Limine host tool and the compiled bootloader
# artifacts for all supported architectures.
{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "8.0.11";
in
stdenv.mkDerivation {
  inherit version;
  pname = "limine";
  # We download the source to build the host tool and the pre cross-compiled
  # bootloader artifacts for all architectures. Experiences showed that it is
  # cumbersome to build them in a Nix derivation.
  src = fetchurl {
    url = "https://github.com/limine-bootloader/limine/archive/refs/tags/v${version}-binary.tar.gz";
    sha256 = "sha256-A0CYnQSs546h1h0pqiEdvPS9tHWrzDtxZ1l1CZmSnFw=";
  };

  doConfigure = false;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # The host tool
    mkdir -p $out/bin
    cp limine $out/bin

    # Cross-compiled bootloader artifacts
    mkdir -p $out/share/limine
    find -name '*.EFI' -exec cp {} $out/share/limine \;
    find -name '*.bin' -exec cp {} $out/share/limine \;
    find -name 'limine.bin' -exec cp {} $out/share/limine \;
    cp limine-bios.sys $out/share/limine

    runHook postInstall
  '';

  outputs = [
    "out"
    "dev"
  ];

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
    # The platforms on that the Liminine binary and helper tools can run, not
    # necessarily the platforms for that bootable images can be created.
    platforms = platforms.unix;
    maintainers = [
      maintainers._48cf
      maintainers.phip1611
    ];
  };
}
