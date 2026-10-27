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
  qt5,
  tuxclocker-plugins,
  tuxclocker-without-unfree,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxclocker";
  version = "1.5.1-unstable-2026-08-19";

  src = fetchFromGitHub {
    owner = "Lurkki14";
    repo = "tuxclocker";
    fetchSubmodules = true;
    rev = "c7c9021e6c32f3df581f266ccab4275d29810be1";
    hash = "sha256-FMLpzt/VFzzFdn2b8MUxjPowLJu+tHiJhCDum5I6kSU=";
  };

  nativeBuildInputs = [
    git
    makeWrapper
    meson
    ninja
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qt5.qtbase
    qt5.qtcharts
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

  passthru = {
    tests = {
      inherit tuxclocker-without-unfree;
    };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Qt overclocking tool for GNU/Linux";
    homepage = "https://github.com/Lurkki14/tuxclocker";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lurkki ];
    platforms = lib.platforms.linux;
  };
})
