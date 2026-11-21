{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  alsa-lib,
  pipewire,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpwgraph";
  version = "1.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "rncbc";
    repo = "qpwgraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0RqzF67YEhiP94Y1cC7ob1Vv/h3SPFcEqdJh4vmDy0A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    alsa-lib
    pipewire
  ];

  cmakeFlags = [ "-DCONFIG_WAYLAND=ON" ];

  meta = {
    description = "Qt graph manager for PipeWire, similar to QjackCtl";
    longDescription = ''
      qpwgraph is a graph manager dedicated for PipeWire,
      using the Qt C++ framework, based and pretty much like
      the same of QjackCtl.
    '';
    homepage = "https://gitlab.freedesktop.org/rncbc/qpwgraph";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      kanashimia
      exi
      Scrumplex
      matthiasbeyer
    ];
    mainProgram = "qpwgraph";
  };
})
