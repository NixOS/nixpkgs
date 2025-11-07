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
  version = "3.10";

  src = fetchFromGitHub {
    owner = "horsicq";
    repo = "DIE-engine";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-yHgxYig5myY2nExweUk2muKbJTKN3SiwOLgQcMIY/BQ=";
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

  postInstall = ''
    cp -r $src/XYara/yara_rules $out/lib/die/
  '';

  meta = {
    description = "Program for determining types of files for Windows, Linux and MacOS";
    mainProgram = "die";
    homepage = "https://github.com/horsicq/Detect-It-Easy";
    changelog = "https://github.com/horsicq/Detect-It-Easy/blob/master/changelog.txt";
    maintainers = with lib.maintainers; [ ivyfanchiang ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.mit;
  };
})
