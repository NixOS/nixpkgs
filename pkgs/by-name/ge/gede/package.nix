{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
  libsForQt5,
  ctags,
  gdb,
}:

stdenv.mkDerivation rec {
  pname = "gede";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "jhn98032";
    repo = "gede";
    tag = "v${version}";
    hash = "sha256-jNV51hUCQ7Vcv677zHq1DSla8Oz3Z5ON9fX05pwiL4k=";
  };

  nativeBuildInputs = [
    ctags
    makeWrapper
    python3
    libsForQt5.qmake
    libsForQt5.qtserialport
    libsForQt5.wrapQtAppsHook
  ];

  strictDeps = true;

  dontUseQmakeConfigure = true;

  dontBuild = true;

  installPhase = ''
    python build.py install --verbose --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix QT_PLUGIN_PATH : ${libsForQt5.qtbase}/${libsForQt5.qtbase.qtPluginPrefix} \
      --prefix PATH : ${
        lib.makeBinPath [
          ctags
          gdb
        ]
      }
  '';

  meta = {
    description = "Graphical frontend (GUI) to GDB";
    mainProgram = "gede";
    homepage = "http://gede.dexar.se";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ juliendehos ];
  };
}
