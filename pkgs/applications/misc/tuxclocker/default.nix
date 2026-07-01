{
  lib,
  stdenv,
  boost,
  fetchFromGitHub,
  git,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  python3,
  qtbase,
  qtcharts,
  tuxclocker-plugins,
  tuxclocker-without-unfree,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxclocker";
  version = "1.5.1-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "Lurkki14";
    repo = "tuxclocker";
    fetchSubmodules = true;
    rev = "e244b4465a52d41932c7350779a0058a8a6fd4ae";
    hash = "sha256-Fp+iVdAXwIR6Or9JGA/W4cAcePbmSqrB3iSOP41v3qw=";
  };

  nativeBuildInputs = [
    git
    makeWrapper
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qtbase
    qtcharts
  ];

  postInstall = ''
    wrapProgram "$out/bin/tuxclockerd" \
      --prefix "TEXTDOMAINDIR" : "${tuxclocker-plugins}/share/locale" \
      --prefix "TUXCLOCKER_PLUGIN_PATH" : "${tuxclocker-plugins}/lib/tuxclocker/plugins" \
      --prefix "PYTHONPATH" : "${python3.pkgs.hwdata}/${python3.sitePackages}"
  '';

  mesonFlags = [
    "-Dplugins=false"
  ];

  passthru.tests = {
    inherit tuxclocker-without-unfree;
  };

  meta = {
    description = "Qt overclocking tool for GNU/Linux";
    homepage = "https://github.com/Lurkki14/tuxclocker";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lurkki ];
    platforms = lib.platforms.linux;
  };
})
