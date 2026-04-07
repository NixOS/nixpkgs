{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  testers,

  addDriverRunpath,
  autoAddDriverRunpath,
  apple-sdk_15,
  cmake,
  freetype,
  libGL,
  libx11,
  libxaw,
  libxcb,
  libxrandr,
  libxt,
  ninja,
  openvr,
  pkg-config,
  rapidjson,
  SDL2,
  tinyxml,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  zlib,
  zziplib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ogre-next";
  version = "2.3.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-elSj35LwsLzj1ssDPsk9NW/KSXfiOGYmw9hQSAWdpFM=";
  };

  patches = [
    # Backport from v2-3 branch: implement STBIImageCodec::magicNumberToFileExt()
    # so Image2::load() can identify PNG/JPEG files by magic bytes.
    # Without this, TextureGpuManager texture loading crashes.
    # TODO: Remove after update to > 2.3.3
    (fetchpatch2 {
      url = "https://github.com/OGRECave/ogre-next/commit/65e6a9bad2a2e8e8839a0b62b8a54d64e368a492.patch?full_index=1";
      hash = "sha256-Zw6pFjHbDezbO79SLD/yo9tblgph1PKH58PV7r1dcZM=";
    })
    # Backport from v2-3 branch: fix infinite-loop typo (x << width → x < width)
    # and wrong source stride in RGB→RGBA conversion in STBICodec::decode().
    # TODO: Remove after update to > 2.3.3
    (fetchpatch2 {
      url = "https://github.com/OGRECave/ogre-next/commit/5d2767e201f36e85ce8fb641449b87262e9674df.patch?full_index=1";
      hash = "sha256-MgqoU9cw0vJcgI7hLuqlVRFdmOTwmQ93FBTgzDl69hg=";
    })
    # Fix RGB channel swap in STBICodec RGB→RGBA conversion: stb returns
    # RGB but the code wrote r,g,b (actually B,G,R) into PFG_RGBA8_UNORM.
    # master (v3-0) already has the correct write order; this backports it.
    # https://github.com/OGRECave/ogre-next/pull/567
    ./patches/pr-567.patch
    # Skip NSWindow creation for hidden (offscreen) Metal windows.
    # NSWindow must be created on the main thread on macOS; skipping it
    # makes hidden windows safe to create from any thread, analogous to
    # VulkanWindowNull in the Vulkan backend.
    # https://github.com/OGRECave/ogre-next/pull/566
    ./patches/pr-566.patch
    # GCC 15 enforces CWG DR 1518: explicit default constructors cannot be
    # used in copy-list-initialization. Remove `explicit` from STLAllocator's
    # default constructor so STL containers can value-initialize their allocator.
    # https://github.com/OGRECave/ogre-next/pull/564
    ./patches/pr-564.patch
    # Guard macOS framework post-build commands (ditto, mkdir) behind
    # OGRE_BUILD_LIBS_AS_FRAMEWORKS so they are skipped when disabled.
    # https://github.com/OGRECave/ogre-next/pull/569
    ./patches/pr-569.patch
    # Respect externally-set CMAKE_OSX_SYSROOT on macOS instead of
    # unconditionally overriding it via xcodebuild.
    # https://github.com/OGRECave/ogre-next/pull/570
    ./patches/pr-570.patch
    # Fix pkgconfig plugindir on macOS: plugins install to lib/ directly,
    # not lib/OGRE/.
    # https://github.com/OGRECave/ogre-next/pull/571
    ./patches/pr-571.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoAddDriverRunpath
  ];

  buildInputs = [
    SDL2
    freetype
    rapidjson
    tinyxml
    zlib
    zziplib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxaw
    libxcb
    libxrandr
    libxt
    openvr
    shaderc.dev
    shaderc.static
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  cmakeFlags = [
    (lib.cmakeBool "OGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS" true)
    # Use STB instead of FreeImage (marked insecure in nixpkgs)
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_FREEIMAGE" false)
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_STBI" true)
    # Framework bundles are incompatible with the Nix store
    (lib.cmakeBool "OGRE_BUILD_LIBS_AS_FRAMEWORKS" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # OGRE-Next is a fork of OGRE; use the "OgreNext" library prefix
    # (e.g. OgreNextMain, OgreNextHlmsPbs) to avoid conflicts with OGRE 1.x.
    # macOS retains the "OGRE" name by convention (matching Homebrew builds).
    (lib.cmakeBool "OGRE_USE_NEW_PROJECT_NAME" true)
    # Render systems: GL3Plus and Vulkan are Linux-only; the GL3Plus window
    # subsystem is not ported to the 2.x series on macOS, and Vulkan uses
    # XCB windowing which is Linux-only.
    (lib.cmakeBool "OGRE_BUILD_RENDERSYSTEM_GL3PLUS" true)
    (lib.cmakeBool "OGRE_GLSUPPORT_USE_EGL_HEADLESS" true)
    (lib.cmakeBool "OGRE_BUILD_RENDERSYSTEM_VULKAN" true)
    # Headless Vulkan rendering (no display server required)
    (lib.cmakeBool "OGRE_VULKAN_WINDOW_NULL" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # GL3Plus and Vulkan are not available on macOS; Metal is the
    # primary render system (built automatically when on Darwin).
    (lib.cmakeBool "OGRE_BUILD_RENDERSYSTEM_GL3PLUS" false)
    (lib.cmakeBool "OGRE_BUILD_RENDERSYSTEM_VULKAN" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # NEON and SSE2 SIMD paths cause build failures on aarch64
    (lib.cmakeBool "OGRE_SIMD_NEON" false)
    (lib.cmakeBool "OGRE_SIMD_SSE2" false)
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    # On Linux OGRE_USE_NEW_PROJECT_NAME renames modules to OGRE-Next-*;
    # on macOS they retain the OGRE-* prefix.
    moduleNames =
      if stdenv.hostPlatform.isLinux then
        [
          "OGRE-Next"
          "OGRE-Next-Hlms"
          "OGRE-Next-MeshLodGenerator"
          "OGRE-Next-Overlay"
        ]
      else
        [
          "OGRE"
          "OGRE-Hlms"
          "OGRE-MeshLodGenerator"
          "OGRE-Overlay"
        ];
    versionCheck = true;
  };

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine (2.x series)";
    homepage = "https://www.ogre3d.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taylorhoward92 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
