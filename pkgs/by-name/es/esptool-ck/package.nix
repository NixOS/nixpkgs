{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "esptool-ck";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "igrr";
    repo = "esptool-ck";
    rev = "0.4.13";
    hash = "sha256-U9gSzzN4BYSmOyMW7CvAkKbunsICzvpAPDkcBcYKaLE=";
  };

  makeFlags = [ "VERSION=${finalAttrs.version}" ];

  installPhase = ''
    mkdir -p $out/bin
    cp esptool $out/bin
  '';

  meta = {
    description = "ESP8266/ESP32 build helper tool";
    homepage = "https://github.com/igrr/esptool-ck";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "esptool";
  };
})
