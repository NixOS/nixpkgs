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
<<<<<<< HEAD
  version = "unstable-2023-06-12";
=======
  version = "unstable-2023-03-19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "superctr";
    repo = "mmlgui";
<<<<<<< HEAD
    rev = "d680f576aba769b0d63300fbed57a0e9e54dfa4b";
    fetchSubmodules = true;
    hash = "sha256-BqwayGQBIa0ru22Xci8vHNYPFr9scZSdrUOlDtGBnno=";
=======
    rev = "59ac28c0008e227c03799cce85b77f96241159b1";
    fetchSubmodules = true;
    sha256 = "0CHRUizhg/WOWhDOsFqRiGu/m/U7xt5du8Uvnl7kxpU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Actually wants pkgconf but that seems abit broken:
    # https://github.com/NixOS/nixpkgs/pull/147503#issuecomment-1055943897
    # Removing a pkgconf-specific option makes it work with pkg-config
    substituteInPlace libvgm.mak \
      --replace '--with-path=/usr/local/lib/pkgconfig' ""
<<<<<<< HEAD

    # Use correct pkg-config
    substituteInPlace {imgui,libvgm}.mak \
      --replace 'pkg-config' "\''$(PKG_CONFIG)"

    # Don't force building tests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace Makefile \
      --replace 'all: $(MMLGUI_BIN) test' 'all: $(MMLGUI_BIN)'
  '';

<<<<<<< HEAD
  strictDeps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  checkInputs = [
=======
  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cppunit
  ];

  makeFlags = [
    "RELEASE=1"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
