{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  pkg-config,
  glfw,
  libvgm,
  libx11,
  libxau,
  libxdmcp,
  cppunit,
}:

stdenv.mkDerivation {
  pname = "mmlgui";
  version = "210420-preview-unstable-2026-01-09";

  src = fetchFromGitHub {
    owner = "superctr";
    repo = "mmlgui";
    rev = "9803a154c5fdbe6e88956e391ea0d5c4eae18cdc";
    fetchSubmodules = true;
    hash = "sha256-3HMSVSgqusIhFf7jheyC2ytoJqSsJA8yYUnhxvdteq0=";
  };

  postPatch = ''
    # Actually wants pkgconf but that seems abit broken:
    # https://github.com/NixOS/nixpkgs/pull/147503#issuecomment-1055943897
    # Removing a pkgconf-specific option makes it work with pkg-config
    substituteInPlace libvgm.mak \
      --replace '--with-path=/usr/local/lib/pkgconfig' ""

    # Use correct pkg-config
    substituteInPlace {imgui,libvgm}.mak \
      --replace 'pkg-config' "\''$(PKG_CONFIG)"

    # Don't force building tests
    substituteInPlace Makefile \
      --replace 'all: $(MMLGUI_BIN) test' 'all: $(MMLGUI_BIN)'

    # Breaking change in libvgm
    substituteInPlace src/emu_player.cpp \
      --replace 'Resmpl_SetVals(&resmpl, 0xff' 'Resmpl_SetVals(&resmpl, RSMODE_LINEAR'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glfw
    libvgm
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxau
    libxdmcp
  ];

  checkInputs = [
    cppunit
  ];

  makeFlags = [
    "RELEASE=1"
  ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installPhase = ''
    runHook preInstall

    install -Dm755 {,$out/}bin/mmlgui
    mkdir -p $out/share/ctrmml
    mv ctrmml/sample $out/share/ctrmml/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/superctr/mmlgui.git";
  };

  meta = {
    homepage = "https://github.com/superctr/mmlgui";
    description = "MML (Music Macro Language) editor and compiler GUI, powered by the ctrmml framework";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
    mainProgram = "mmlgui";
  };
}
