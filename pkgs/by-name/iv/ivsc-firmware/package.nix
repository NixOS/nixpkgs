{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "ivsc-firmware";
  version = "unstable-2024-06-14";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-firmware";
    rev = "74a01d1208a352ed85d76f959c68200af4ead918";
    hash = "sha256-kHYfeftMtoOsOtVN6+XoDMDHP7uTEztbvjQLpCnKCh0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/vsc
    cp --no-preserve=mode --recursive ./firmware/* $out/lib/firmware/vsc/
    install -D ./LICENSE $out/share/doc

    mkdir -p $out/lib/firmware/vsc/soc_a1_prod
    # According to Intel's documentation for prod platform the a1_prod postfix is need it (https://github.com/intel/ivsc-firmware)
    # This fixes ipu6 webcams
    for file in $out/lib/firmware/vsc/*.bin; do
      ln -sf "$file" "$out/lib/firmware/vsc/soc_a1_prod/$(basename "$file" .bin)_a1_prod.bin"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware binaries for the Intel Vision Sensing Controller";
    homepage = "https://github.com/intel/ivsc-firmware";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
