{
  lib,
  stdenv,
  fetchFromGitLab,

  # nativeBuildInputs
  protobuf,
  qt5,
  libsForQt5,
  pkg-config,
  installShellFiles,

  # buildInputs
  ghostscript,
  poppler-utils,
  exempi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "equalx";
  version = "0.7.1-unstable-2020-02-26";

  src = fetchFromGitLab {
    owner = "q-quark";
    repo = "equalx";
    rev = "b7175a574379d86c43cabbdb6071f0b6d40d8e79";
    hash = "sha256-3KIJk5bTmFjaojjHDurJjEgyvuIf0LHcSi+MrmsRPcg=";
  };
  postPatch = ''
    substituteInPlace equalx.pro \
      --replace-fail 'git describe --abbrev=0 --tags' 'echo ${finalAttrs.version}'
  '';

  nativeBuildInputs = [
    protobuf
    qt5.qmake
    qt5.wrapQtAppsHook
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    libsForQt5.poppler
    ghostscript
    poppler-utils
    exempi
  ];

  installPhase = ''
    runHook preInstall

    installBin equalx
    installManPage equalx.1
    install -Dm644 equalx.appdata.xml $out/share/metainfo/eqaulx.appdata.xml
    install -Dm644 resources/equalx.ico $out/share/icons/hicolor/256x256/apps/equalx.ico
    install -Dm644 resources/equalx.desktop $out/share/applications/equalx.desktop

    runHook postInstall
  '';

  meta = {
    description = "Graphical interface to latex and a bunch of conversion programs";
    homepage = "https://equalx.sourceforge.io/";
    mainProgram = "equalx";
    downloadPage = "https://gitlab.com/q-quark/equalx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
