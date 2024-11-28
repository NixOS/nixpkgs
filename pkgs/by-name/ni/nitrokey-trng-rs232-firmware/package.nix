{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsCross,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nitrokey-trng-rs232-firmware";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-trng-rs232-firmware";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vY/9KAGB6lTkkjW9zUiHA3wD2d35cEBVBTr12bHCy4k=";
  };

  nativeBuildInputs = [ pkgsCross.avr.stdenv.cc ];

  sourceRoot = "source/src";

  makeFlags = [ "all" ];

  installPhase = ''
    runHook preInstall
    install -D TRNGSerial.bin $out/TRNGSerial.bin
    runHook postInstall
  '';

  meta = {
    description = "Firmware for the Nitrokey TRNG RS232 device";
    longDescription = ''
      This package does not provide an executable. It should be built using `nix-build -A nitrokey-trng-rs232-firmware` or `nix build nixpkgs#nitrokey-trng-rs232-firmware` and flashed using `libnitrokey`
    '';
    homepage = "https://github.com/Nitrokey/nitrokey-trng-rs232-firmware";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      amerino
      imadnyc
      kiike
    ];
    platforms = lib.platforms.linux;
  };
})
