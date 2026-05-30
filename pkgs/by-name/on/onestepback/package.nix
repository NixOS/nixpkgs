{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onestepback";
  version = "0.997";

  srcs = [
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/pages/onestepback/OneStepBack-v${finalAttrs.version}.zip";
      hash = "sha256-uB6pfnTkMKeP71rAvn1olJJeCL84222UT5uxG72sywE=";
    })
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/pages/onestepback/OneStepBack-wm2-v${finalAttrs.version}.zip";
      hash = "sha256-Zdv4ZrQPficbCxPBKF3RFNavlSn/VV/efiZVUT86zRc=";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p  $out/share/themes
    cp -a OneStepBack* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
    runHook postInstall
  '';

  meta = {
    description = "Gtk theme inspired by the NextStep look";
    homepage = "http://www.vide.memoire.free.fr/pages/onestepback";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
})
