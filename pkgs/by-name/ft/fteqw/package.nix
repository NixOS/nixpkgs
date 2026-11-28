{
  lib,
  stdenv,
  fetchFromGitHub,
  addDriverRunpath,
  bullet,
  bzip2,
  cmake,
  dbus,
  ffmpeg,
  fontconfig,
  freetype,
  gettext,
  gnutls,
  libtasn1,
  libidn2,
  p11-kit,
  libGL,
  libjpeg,
  libopus,
  libpng,
  libsForQt5,
  libvorbis,
  makeWrapper,
  ninja,
  nix-update-script,
  openal,
  openxr-loader,
  pkg-config,
  sdl2-compat,
  sdl3,
  speex,
  speexdsp,
  sqlite,
  vulkan-headers,
  vulkan-loader,
  zip,
  zlib,
  withQccGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fteqw";
  version = "2025-09-27";

  src = fetchFromGitHub {
    owner = "fte-team";
    repo = "fteqw";
    tag = finalAttrs.version;
    hash = "sha256-C6v7lxuqsqX/Wo6oKi5yeD8QNYTg5wFxWo03qGszkQ8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/bin/echo" "echo" \
      --replace-fail 'EMBED_PLUGIN_META(irc "MPQ' 'EMBED_PLUGIN_META(mpq "MPQ'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    zip
    gettext
    makeWrapper
  ]
  ++ lib.optional withQccGui libsForQt5.wrapQtAppsHook;

  buildInputs = [
    zlib
    bzip2
    libpng
    libjpeg
    freetype
    fontconfig
    libvorbis
    sdl3
    sdl2-compat
    vulkan-headers
    openxr-loader
    bullet
    ffmpeg
    gnutls
    libtasn1
    p11-kit
    libidn2
    dbus
  ]
  ++ lib.optionals withQccGui [
    libsForQt5.qtbase
    libsForQt5.qscintilla
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_C_STANDARD" "11")
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "11")
    (lib.cmakeFeature "FTE_INSTALL_BINDIR" "bin")
    (lib.cmakeBool "FTE_DEP_SDL3" true)
    (lib.cmakeBool "FTE_TOOL_IQM" true)
    (lib.cmakeBool "FTE_TOOL_IMAGE" true)
    (lib.cmakeBool "FTE_TOOL_QTV" true)
    (lib.cmakeBool "FTE_TOOL_MASTER" true)
    (lib.cmakeBool "FTE_TOOL_QCVM" true)
    (lib.cmakeBool "FTE_TOOL_QCC" true)
    (lib.cmakeBool "FTE_TOOL_QCCGUI" withQccGui)
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
    (lib.cmakeBool "FTE_PLUG_CEF" false)
    (lib.cmakeBool "FTE_PLUG_ODE" false)
    (lib.cmakeBool "FTE_PLUG_NAMEMAKER" false)
    (lib.cmakeBool "FTE_PLUG_TERRAINGEN" false)
    (lib.cmakeBool "FTE_PLUG_X11SV" false)
  ];

  # https://github.com/fte-team/fteqw/issues/472
  hardeningDisable = [ "fortify" ];

  # strip drops the zip metadata appended to plugins
  stripExclude = [ "fteplug_*.so" ];

  dontWrapQtApps = true;

  postFixup =
    let
      svLibs = [
        gnutls
        sqlite
      ];
      clLibs = svLibs ++ [
        libGL
        vulkan-loader
        libvorbis
        openal
        speex
        speexdsp
        libopus
      ];
    in
    # client dlopens through SDL_LoadObject, so its own rpath is never searched
    ''
      wrapProgram $out/bin/fteqw \
        --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath clLibs}"
      patchelf --add-rpath "${lib.makeLibraryPath svLibs}" $out/bin/fteqw-sv
    ''
    + lib.optionalString withQccGui ''
      wrapQtApp $out/bin/fteqccgui
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hybrid and versatile game engine";
    longDescription = ''
      FTE is a game engine based on QuakeWorld able to
      play games such as Quake 1, 2, 3, and Hexen 2.
      It includes various features such as extended map
      limits, vulkan and OpenGL renderers, a dedicated
      server, and fteqcc, for easier QuakeC development
    '';

    homepage = "https://fteqw.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      necrophcodr
      keenanweaver
    ];
    mainProgram = "fteqw";
    platforms = lib.platforms.linux;
  };
})
