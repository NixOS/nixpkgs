{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  makeWrapper,
  pkg-config,
  zip,
  gettext,
  gzip,
  bzip2,
  freetype,
  libvorbis,
  libmad,
  sdl3,
  sdl3-mixer,
  sdl2-compat,
  libpng,
  alsa-lib,
  gnutls,
  zlib,
  libjpeg,
  lame,
  vulkan-loader,
  vulkan-headers,
  openxr-loader,
  speex,
  libopus,
  ffmpeg_7-full,
  libxrandr,
  libxcursor,
  libxscrnsaver,
  libxcb,
  libx11,
  libxxf86vm,
  libxxf86dga,
  libxi,
  libxkbcommon,
  libxdmcp,
  fontconfig,
  libtasn1,
  bullet,
  sqlite,
  openexr,
  addDriverRunpath,
  libGL,
  wayland,
  wayland-protocols,
  expat,
  libidn2,
  p11-kit,
  libsForQt5,
  version ? "2025-09-27",
}@attrs:

stdenv.mkDerivation (finalAttrs: {
  pname = "fteqw";
  version = version;

  src = fetchFromGitHub {
    owner = "fte-team";
    repo = "fteqw";
    tag = finalAttrs.version;
    hash = "sha256-C6v7lxuqsqX/Wo6oKi5yeD8QNYTg5wFxWo03qGszkQ8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    pkg-config
    zip
    gettext
    vulkan-headers
    libsForQt5.qtbase
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    gzip
    bzip2
    libvorbis
    libmad
    sdl3
    sdl3-mixer
    sdl2-compat
    libGL
    libpng
    alsa-lib
    gnutls
    freetype
    libjpeg
    lame
    bullet
    vulkan-loader
    openxr-loader
    speex
    libopus
    ffmpeg_7-full
    libxrandr
    libxcursor
    libxscrnsaver
    libxcb
    libxkbcommon
    libxdmcp
    fontconfig
    libtasn1
    wayland
    wayland-protocols
    expat
    libidn2
    p11-kit
    libsForQt5.qscintilla
    libsForQt5.qwt
  ];

  postFixup =
    let
      libs = [
        addDriverRunpath.driverLink

        # gl/gl_vidlinuxglx.c
        libx11
        libxrandr
        libxxf86vm
        libxxf86dga
        libxi
        libxcursor
        libGL

        libvorbis

        sqlite # server/sv_sql.c

        vulkan-loader
        sdl3
        # sdl2-compat
        # SDL2 # a lot of different files
        gnutls # common/net_ssl_gnutls.c
        openexr # client/image.c

        (placeholder "out")
      ];
      svlibs = [
        sqlite # server/sv_sql.c
        gnutls # common/net_ssl_gnutls.c
        openexr # client/image.c

        (placeholder "out")
      ];
    in
    ''
      wrapProgram $out/bin/fteqw \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
      wrapProgram $out/bin/fteqw-sv \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath svlibs}"
    '';

  hardeningDisable = [ "fortify" ];

  cmakeFlags = [
    (lib.cmakeBool "FTE_TOOL_IQM" true)
    (lib.cmakeBool "FTE_TOOL_IMAGE" true)
    (lib.cmakeBool "FTE_TOOL_QTV" true)
    (lib.cmakeBool "FTE_TOOL_MASTER" true)
    (lib.cmakeBool "FTE_TOOL_QCVM" true)
    (lib.cmakeBool "FTE_TOOL_QCC" true)
    (lib.cmakeBool "FTE_TOOL_QCCGUI" true)
    (lib.cmakeBool "FTE_TOOL_HTTPSV" true)
    (lib.cmakeBool "FTE_MENU_SYS" true)
    (lib.cmakeBool "FTE_CSADDON" true)
    (lib.cmakeBool "FTE_PLUG_COD" true)
    (lib.cmakeBool "FTE_PLUG_BULLET" true)
    (lib.cmakeBool "FTE_PLUG_EZHUD" true)
    (lib.cmakeBool "FTE_PLUG_FFMPEG" true)
    (lib.cmakeBool "FTE_PLUG_IRC" true)
    (lib.cmakeBool "FTE_PLUG_HL2" true)
    (lib.cmakeBool "FTE_PLUG_MPQ" true)
    (lib.cmakeBool "FTE_PLUG_OPENXR" true)
    (lib.cmakeBool "FTE_PLUG_QI" true)
    (lib.cmakeBool "FTE_PLUG_QUAKE3" true)
    (lib.cmakeBool "FTE_PLUG_XMPP" true)
    (lib.cmakeBool "FTE_DEP_SDL3" true)
    (lib.cmakeBool "FTE_PLUG_CEF" false)
    (lib.cmakeBool "FTE_PLUG_ODE" false)
    (lib.cmakeBool "FTE_PLUG_NAMEMAKER" false)
    (lib.cmakeBool "FTE_PLUG_TERRAINGEN" false)
    (lib.cmakeBool "FTE_PLUG_X11SV" false)
  ];

  CFLAGS = [
    "-std=gnu11"
  ];
  CXXFLAGS = [
    "-std=gnu++11"
  ];

  enableParallelBuilding = true;
  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace "/bin/echo" "echo"
  '';

  postInstall = ''
    mv $out/games $out/bin
  '';

  meta = {
    description = "Hybrid and versatile game engine";
    homepage = "https://fteqw.org";
    longDescription = ''
      FTE is a game engine baed on QuakeWorld able to
      play games such as Quake 1, 2, 3, and Hexen 2.
      It includes various features such as extended map
      limits, vulkan and OpenGL renderers, a dedicated
      server, and fteqcc, for easier QuakeC development
    '';
    maintainers = with lib.maintainers; [ necrophcodr ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
