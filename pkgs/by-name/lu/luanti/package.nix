{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  cmake,
  coreutils,
  libpng,
  bzip2,
  curl,
  libogg,
  jsoncpp,
  libjpeg,
  libGLU,
  openal,
  libvorbis,
  sqlite,
  luajit,
  freetype,
  gettext,
  doxygen,
  ncurses,
  graphviz,
  libxi,
  libx11,
  gmp,
  libspatialindex,
  leveldb,
  libpq,
  hiredis,
  libiconv,
  ninja,
  prometheus-cpp,
  buildClient ? true,
  buildServer ? true,
  SDL2,
  sdl3,
  # Use SDL3 (experimental) instead of SDL2
  useSdl3 ? false,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luanti";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "luanti-org";
    repo = "luanti";
    tag = finalAttrs.version;
    hash = "sha256-ooZyyVFbf8OreYYs3XZlTht10cpdzsRgbOUWyaqX4jw=";
  };

  patches = [
    (substitute {
      src = ./0000-mark-rm-for-substitution.patch;
      substitutions = [
        "--subst-var-by"
        "RM_COMMAND"
        "${coreutils}/bin/rm"
      ];
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '/pagezero_size/d;/fixup_bundle/d' src/CMakeLists.txt
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CLIENT" buildClient)
    (lib.cmakeBool "BUILD_SERVER" buildServer)
    (lib.cmakeBool "BUILD_UNITTESTS" (finalAttrs.finalPackage.doCheck or false))
    (lib.cmakeBool "ENABLE_PROMETHEUS" buildServer)
    (lib.cmakeBool "USE_SDL3" useSdl3)
    # Ensure we use system libraries
    (lib.cmakeBool "ENABLE_SYSTEM_GMP" true)
    (lib.cmakeBool "ENABLE_SYSTEM_JSONCPP" true)
    # Updates are handled by nix anyway
    (lib.cmakeBool "ENABLE_UPDATE_CHECKER" false)
    # ...but make it clear that this is a nix package
    (lib.cmakeFeature "VERSION_EXTRA" "NixOS")
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    ninja
  ];

  buildInputs = [
    jsoncpp
    gettext
    freetype
    sqlite
    curl
    bzip2
    ncurses
    gmp
    libspatialindex
  ]
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform luajit) luajit
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals buildClient [
    libpng
    libjpeg
    libGLU
    openal
    libogg
    libvorbis
    (if useSdl3 then sdl3 else SDL2)
  ]
  ++ lib.optionals (buildClient && !stdenv.hostPlatform.isDarwin) [
    libx11
    libxi
  ]
  ++ lib.optionals buildServer [
    leveldb
    libpq
    hiredis
    prometheus-cpp
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchShebangs $out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/luanti.app $out/Applications
    '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.luanti.org/";
    description = "Open source voxel game engine (formerly Minetest)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      fpletz
      fgaz
      jk
    ];
    mainProgram = if buildClient then "luanti" else "luantiserver";
  };
})
