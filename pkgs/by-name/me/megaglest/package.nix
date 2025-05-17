{
  lib,
  stdenv,
  cmake,
  pkg-config,
  git,
  curl,
  SDL2,
  xercesc,
  openal,
  lua,
  libvlc,
  libjpeg,
  wxGTK32,
  cppunit,
  ftgl,
  glew,
  libogg,
  libvorbis,
  buildEnv,
  libpng,
  fontconfig,
  freetype,
  xorg,
  makeWrapper,
  bash,
  which,
  zenity,
  libGLU,
  glib,
  fetchFromGitHub,
  fetchpatch,
}:
let
  version = "3.13.0";
  lib-env = buildEnv {
    name = "megaglest-lib-env";
    paths = [
      SDL2
      xorg.libSM
      xorg.libICE
      xorg.libX11
      xorg.libXext
      xercesc
      openal
      libvorbis
      lua
      libjpeg
      libpng
      curl
      fontconfig
      ftgl
      freetype
      stdenv.cc.cc
      glew
      libGLU
      wxGTK32
    ];
  };
  path-env = buildEnv {
    name = "megaglest-path-env";
    paths = [
      bash
      which
      zenity
    ];
  };
in
stdenv.mkDerivation {
  pname = "megaglest";
  inherit version;

  src = fetchFromGitHub {
    owner = "MegaGlest";
    repo = "megaglest-source";
    tag = version;
    fetchSubmodules = true;
    sha256 = "0fb58a706nic14ss89zrigphvdiwy5s9dwvhscvvgrfvjpahpcws";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/MegaGlest/megaglest-source/commit/5a3520540276a6fd06f7c88e571b6462978e3eab.patch";
      sha256 = "0y554kjw56dikq87vs709pmq97hdx9hvqsk27f81v4g90m3b3qhi";
    })
    # Pull upstream and Debian fixes for wxWidgets 3.2
    (fetchpatch {
      name = "get-rid-of-manual-wxPaintEvent-creation-1.patch";
      url = "https://github.com/MegaGlest/megaglest-source/commit/e09ba53c436279588f769d6ce8852e74d58f8391.patch";
      hash = "sha256-1ZG6AjnLXW18wwad05kjH7W5rTaP1SDpZ5zLH4nRQt4=";
    })
    (fetchpatch {
      name = "get-rid-of-manual-wxPaintEvent-creation-2.patch";
      url = "https://sources.debian.org/data/main/m/megaglest/3.13.0-9/debian/patches/fbd0cfb17ed759d24aeb577a602b0d97f7895cc2.patch";
      hash = "sha256-aMDDboNdH22r7YOiZCEApwz+FpM60anBp82tLwiIH6g=";
    })
    (fetchpatch {
      name = "get-rid-of-manual-wxPaintEvent-creation-3.patch";
      url = "https://github.com/MegaGlest/megaglest-source/commit/5801b1fafff8ad9618248d4d5d5c751fdf52be2f.patch";
      hash = "sha256-/RpBoT1JsSFtOrAXphHrPp9DnTbaEN/2h8EZmQ9PIPU=";
    })
    (fetchpatch {
      name = "fix-editor-and-g3dviewer-for-wx-3.1.x.patch";
      url = "https://github.com/MegaGlest/megaglest-source/commit/789e1cdf371137b729e832e28a5feb6e97a3a243.patch";
      hash = "sha256-fK7vkHCu6bqVB6I7vMsWMGiczSdxVgo1KqqBNMkEbfM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    git
  ];
  buildInputs = [
    curl
    SDL2
    xorg.libX11
    xercesc
    openal
    lua
    libpng
    libjpeg
    libvlc
    wxGTK32
    glib
    cppunit
    fontconfig
    freetype
    ftgl
    glew
    libogg
    libvorbis
    libGLU
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_MEGAGLEST=On"
    "-DBUILD_MEGAGLEST_MAP_EDITOR=On"
    "-DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS=On"
    "-DBUILD_MEGAGLEST_MODEL_VIEWER=On"
  ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix LD_LIBRARY_PATH ":" "${lib-env}/lib" \
        --prefix PATH ":" "${path-env}/bin"
    done
  '';

  meta = with lib; {
    description = "Entertaining free (freeware and free software) and open source cross-platform 3D real-time strategy (RTS) game";
    license = licenses.gpl3;
    homepage = "https://megaglest.org/";
    maintainers = [ maintainers.matejc ];
    platforms = platforms.linux;
  };
}
