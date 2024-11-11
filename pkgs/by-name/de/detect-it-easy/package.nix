{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  freetype,
  graphite2,
  icu,
  krb5,
  systemdLibs,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "detect-it-easy";
  version = "3.09";

  src = fetchFromGitHub {
    owner = "horsicq";
    repo = "DIE-engine";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-A9YZBlGf3j+uSefPiDhrS1Qtu6vaLm4Yodt7BioGD2Q=";
  };

  patches = [ ./0001-remove-hard-coded-paths-in-xoptions.patch ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qtsvg
    graphite2
    freetype
    icu
    krb5
    systemdLibs
  ];
  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    imagemagick
  ];

  enableParallelBuilding = true;

  # work around wrongly created dirs in `install.sh`
  # https://github.com/horsicq/DIE-engine/issues/110
  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
  '';

  # clean up wrongly created dirs in `install.sh` and broken .desktop file
  postInstall = ''
    rm -r $out/lib/{bin,share}
    grep -v "Version=#VERSION#" $src/LINUX/die.desktop > $out/share/applications/die.desktop
  '';

  meta = {
    description = "Program for determining types of files for Windows, Linux and MacOS.";
    mainProgram = "die";
    homepage = "https://github.com/horsicq/Detect-It-Easy";
    maintainers = with lib.maintainers; [ ivyfanchiang ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
  };
})
