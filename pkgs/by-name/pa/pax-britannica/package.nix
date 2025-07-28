{
  lib,
  stdenv,
  copyDesktopItems,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  luajit_2_0,
  libGL,
  libGLU,
  alsa-lib,
  xorg,
  glfw2,
  glfw3,
  useGlfw3 ? false,
}:

stdenv.mkDerivation {
  pname = "pax-britannica";
  version = "1.0.0-5";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "games-team";
    repo = "pax-britannica";
    rev = "00ccbac55fe6ff1217e0870d69ea403b05292c53";
    hash = "sha256-j69di+3P+vaFzv8Zke1MdABMkLtknTNvlfPk1YVUfmU=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pax-britannica/1.0.0-5/debian/patches/compile_for_linux.patch";
      hash = "sha256-XncjmJrBakz5/w90O6rDif2rWSoAVKzuPEj9wN2VNvQ=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pax-britannica/1.0.0-5/debian/patches/add_manpage.patch";
      hash = "sha256-c8O6t0Zv/ln7WiPdbN3sYGsb7SL9Rmeo+94DsjpfgvY=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pax-britannica/1.0.0-5/debian/patches/load_resources_from_usr_share.patch";
      hash = "sha256-61Yt4Rq1I/Ofu640XsDDo0il275B+ozqH0Z6P18XT6Q=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pax-britannica/1.0.0-5/debian/patches/add_desktop_entry.patch";
      hash = "sha256-QSQEBoCw7KTOLgy7TaFvQRpR17HoggTOCxhfTG+kIOA=";
    })
  ]
  ++ lib.optional useGlfw3 (fetchpatch {
    url = "https://sources.debian.org/data/main/p/pax-britannica/1.0.0-5/debian/patches/glfw3.patch";
    hash = "sha256-hj00vnW/i7lxFc4CGlRz6Havkg45gGgIg6MmCXcMsSg=";
  });
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '-DEXTRA_LOADERS=\"../extra_loaders.h\"' '-DEXTRA_LOADERS=\\\"../extra_loaders.h\\\"'
    substituteInPlace dokidoki-support/Makefile \
      --replace-fail '$(STATIC_LINK)' "" \
      --replace-fail '-llua' '-lluajit-5.1'
    substituteInPlace dokidoki-support/minlua.c \
      --replace-fail /usr/share/pax-britannica $out/share/pax-britannica
  '';

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [
    luajit_2_0
    libGL
    libGLU
    alsa-lib
    xorg.libX11
    xorg.libXrandr
    (if useGlfw3 then glfw3 else glfw2)
  ];
  makeFlags =
    if stdenv.hostPlatform.isLinux then
      [ "linux" ]
    else if stdenv.hostPlatform.isDarwin then
      [ "macosx" ]
    else if stdenv.hostPlatform.isMinGW then
      [ "mingw" ]
    else
      throw "Unsupported hostPlatform";

  preBuild = ''
    makeFlagsArray+=(
      EXTRA_LDFLAGS="$(pkg-config --libs alsa x11 xrandr)"
    )
  '';

  desktopItems = [ "pax-britannica.desktop" ];

  installPhase = ''
    mkdir -p $out/{bin,share/pax-britannica,share/pixmaps}
    cp -ar *.lua audio components dokidoki scripts sprites $out/share/pax-britannica/
    cp pax-britannica.png $out/share/pixmaps/
    cp pax-britannica $out/bin/
  '';

  meta = {
    description = "One-button multi-player real-time strategy game";
    homepage = "http://gangles.ca/games/pax-britannica/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ astro ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    mainProgram = "pax-britannica";
  };
}
