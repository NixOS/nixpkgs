{
  lib,
  fetchFromGitLab,
  stdenv,
  cmake,
  boost,
  shared-mime-info,
  rrdtool,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcollectd";
  version = "0.12.2";
  src = fetchFromGitLab {
    owner = "aerusso";
    repo = "kcollectd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-35zb5Kx0tRP5l0hILdomCu2YSQfng02mbyyAClm4uZs=";
  };

  postPatch = lib.optional (!lib.versionOlder rrdtool.version "1.9.0") ''
    substituteInPlace kcollectd/rrd_interface.cc --replace-fail 'char *arg[] =' 'const char *arg[] ='
  '';

  nativeBuildInputs = [
    shared-mime-info
    cmake
  ]
  ++ (with kdePackages; [
    wrapQtAppsHook
    extra-cmake-modules
  ]);

  buildInputs = [
    boost
    rrdtool
  ]
  ++ (with kdePackages; [
    qtbase
    kconfig
    kio
    kxmlgui
    kiconthemes
    ki18n
    kguiaddons
    breeze-icons
  ]);

  meta = {
    description = "Graphical frontend to collectd";
    homepage = "https://www.antonioerusso.com/projects/kcollectd/";
    maintainers = with lib.maintainers; [ symphorien ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kcollectd";
  };
})
