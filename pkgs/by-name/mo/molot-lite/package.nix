{
  lib,
  stdenv,
  fetchFromGitHub,
  lv2,
  cairo,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "molot-lite";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "molot-lite";
    rev = finalAttrs.version;
    sha256 = "sha256-0tmobsdCNon6udbkbQw7+EYQKBg2oaXlHIgNEf9U3XE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    lv2
    cairo
  ];

  makeFlags = [ "INSTALL_DIR=$out/lib/lv2" ];

  installPhase = ''
    runHook preInstall
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Mono_Lite
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Stereo_Lite
    runHook postInstall
  '';

  meta = {
    description = "Stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://github.com/magnetophon/molot-lite";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
