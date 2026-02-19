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
    sha256 = "1cb81b30a71r7i0gmkh2qagfx9lhq0myq5i37fk881bq6g7i5n2k";
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
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
    mainProgram = "esptool";
  };
})
