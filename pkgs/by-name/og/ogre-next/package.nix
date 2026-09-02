{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  testers,

  cmake,
  ninja,
  pkg-config,

  SDL2,
  libxt,
  libxrandr,
  libxaw,
  libx11,
  libxcb,
  libGL,
  zlib,
  freetype,
  tinyxml,
  openvr,
  rapidjson,
  zziplib,
  apple-sdk_15,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ogre-next";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nJkCGKl9+6gApVtqk5OZjTOJllAJIiBKuquTYvR4NPs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/OGRECave/ogre-next/pull/542
      url = "https://github.com/OGRECave/ogre-next/commit/c1dad50e8510dea9d75d97b0ace33a870993895c.patch?full_index=1";
      hash = "sha256-JYsksDxcLrkHqlgdP3KdHlFuvYxNazlchPGoTXE9LYQ=";
    })
  ];

  postPatch = ''
    # OgreMain/CMakeLists.txt has a macOS post-build block that uses `ditto`
    # (a macOS system tool unavailable in the Nix sandbox) to copy headers
    # into an Ogre.framework bundle. This block runs unconditionally on
    # non-iOS macOS — it is not gated by OGRE_BUILD_LIBS_AS_FRAMEWORKS.
    # Wrap it in a framework guard so it is skipped when frameworks are
    # disabled, avoiding the missing `ditto` and the unnecessary framework
    # directory structure.
    substituteInPlace OgreMain/CMakeLists.txt \
      --replace-fail \
        'set(OGRE_OSX_BUILD_CONFIGURATION "$(PLATFORM_NAME)/$(CONFIGURATION)")' \
        'if (OGRE_BUILD_LIBS_AS_FRAMEWORKS)
    set(OGRE_OSX_BUILD_CONFIGURATION "$(PLATFORM_NAME)/$(CONFIGURATION)")' \
      --replace-fail \
        'ogre_config_framework(''${OGRE_NEXT}Main)' \
        'endif ()
    ogre_config_framework(''${OGRE_NEXT}Main)'

    # Remove Xcode-centric CMAKE_OSX_SYSROOT and CMAKE_OSX_ARCHITECTURES overrides.
    # Nix stdenv already sets these correctly via apple-sdk.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(XCODE_ATTRIBUTE_SDKROOT macosx)' "" \
      --replace-fail 'set(CMAKE_OSX_SYSROOT macosx)' "" \
      --replace-fail \
        'execute_process(COMMAND xcodebuild -version -sdk "''${XCODE_ATTRIBUTE_SDKROOT}" Path | head -n 1 OUTPUT_VARIABLE CMAKE_OSX_SYSROOT)' "" \
      --replace-fail \
        'string(REGEX REPLACE "(\r?\n)+$" "" CMAKE_OSX_SYSROOT "''${CMAKE_OSX_SYSROOT}")' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    SDL2
    freetype
    zziplib
    zlib
    tinyxml
    rapidjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxaw
    libxrandr
    libxt
    libxcb
    # openvr is broken on darwin
    openvr
  ]
  # apple-sdk_15 provides Metal, Cocoa, and OpenGL frameworks
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_15;

  # TODO: Figure out Vulkan plugin deps

  cmakeFlags = [
    (lib.cmakeBool "OGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS" true)

    # Use STB instead of freeimage since the latter is marked as insecure
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_FREEIMAGE" false)
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_STBI" true)

    # Framework bundles are incompatible with the Nix store
    (lib.cmakeBool "OGRE_BUILD_LIBS_AS_FRAMEWORKS" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # GL3Plus requires Khronos headers not available on darwin; Metal is the
    # primary render system on macOS
    (lib.cmakeBool "OGRE_BUILD_RENDERSYSTEM_GL3PLUS" false)
  ]
  # Both NEON and SSE2 SIMD cause build failures on aarch64
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    (lib.cmakeBool "OGRE_SIMD_NEON" false)
    (lib.cmakeBool "OGRE_SIMD_SSE2" false)
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = with lib.maintainers; [
      marcin-serwin
    ];
    pkgConfigModules = [
      "OGRE"
      "OGRE-Hlms"
      "OGRE-MeshLodGenerator"
      "OGRE-Overlay"
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mit;
  };
})
