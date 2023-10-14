{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, pkg-config
, glfw
, libvgm
, libX11
, libXau
, libXdmcp
, Carbon
, Cocoa
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "mmlgui";
  version = "unstable-2023-09-20";

  src = fetchFromGitHub {
    owner = "superctr";
    repo = "mmlgui";
    rev = "a941dbcb34d2e1d56ac4489fbec5f893e9b8fb6d";
    fetchSubmodules = true;
    hash = "sha256-d5DznY0WRJpiUEtUQ8Yihc0Ej8+k5cYTqrzUSp/1wg4=";
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
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glfw
    libvgm
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXau
    libXdmcp
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Carbon
    Cocoa
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

  meta = with lib; {
    homepage = "https://github.com/superctr/mmlgui";
    description = "MML (Music Macro Language) editor and compiler GUI, powered by the ctrmml framework";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
