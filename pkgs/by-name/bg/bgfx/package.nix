{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libGL,
  libx11,
  libxcb,
  wayland,
  vulkan-loader,
  directx-shader-compiler,
  glslang,
  spirv-tools,
  spirv-cross,
  meshoptimizer,
  libavif,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "bgfx";
  # bgfx.cmake tags combine the bgfx version and the CMake packaging revision.
  version = "1.164.9539-586";

  # Upstream's CMake project pins a compatible set of bgfx, bx and bimg.
  src = fetchFromGitHub {
    owner = "bkaradzic";
    repo = "bgfx.cmake";
    # v1.164.9539-586; keep the immutable commit as the fetch reference.
    rev = "a0649dcc72ca1dc9fb7ac58e257ae2340be3d070";
    fetchSubmodules = true;
    hash = "sha256-I9HJxnJJapDshch+M80/kQfmWKKpJazSvFrrrHnqqE8=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];
  strictDeps = true;

  # GCC's implicit FMA contraction breaks bx scalar/SIMD bitwise parity on ARM.
  # Keep explicit FMA operations while preventing contraction of ordinary ones.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-ffp-contract=off";

  patches = [
    ./cmake-version.patch
    ./glslang-public-api.patch
    ./system-shader-libraries.patch
    ./system-avif.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ ./system-dxc.patch ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libxcb
      wayland
    ]
    ++ [
      glslang
      spirv-tools
      spirv-cross
      meshoptimizer
      libavif
    ];

  # The exported CMake target links consumers against these libraries.
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
  ];

  # These backends load their libraries at runtime rather than linking them.
  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace bgfx/src/renderer_vk.cpp \
        --replace-fail '"libvulkan.so.1"' '"${lib.getLib vulkan-loader}/lib/libvulkan.so.1"'
      substituteInPlace bgfx/src/glcontext_egl.cpp \
        --replace-fail '"libEGL.so.1"' '"${lib.getLib libGL}/lib/libEGL.so.1"' \
        --replace-fail '"libGL.so.1"' '"${lib.getLib libGL}/lib/libGL.so.1"' \
        --replace-fail '"libGLESv2.so.2"' '"${lib.getLib libGL}/lib/libGLESv2.so.2"' \
        --replace-fail '"libwayland-egl.so.1"' '"${lib.getLib wayland}/lib/libwayland-egl.so.1"'

      substituteInPlace bgfx/tools/shaderc/shaderc_dxil.cpp \
        --replace-fail '"libdxcompiler.so"' '"${lib.getLib directx-shader-compiler}/lib/libdxcompiler.so"'
    ''
    + ''
      # shaderc uses the bundled Tint C++ API; replacing it needs a compatible
      # Dawn/Tint library package. The shader libraries below can be external.
      cp ${./system-shader-libraries.cmake} cmake/bgfx/system-shader-libraries.cmake
    '';

  cmakeFlags = [
    # Source archives lack the Git history used to generate bgfxConfigVersion.cmake.
    (lib.cmakeFeature "BGFX_REV_NUMBER" (lib.versions.patch finalAttrs.version))
    (lib.cmakeFeature "BGFX_LIBRARY_TYPE" "SHARED")
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    (lib.cmakeBool "BGFX_BUILD_EXAMPLES" false)
    (lib.cmakeBool "BGFX_BUILD_TOOLS" true)
    (lib.cmakeBool "BGFX_BUILD_TESTS" false)
    # Avoid collisions with other tools, such as Adobe's bin2c.
    (lib.cmakeFeature "BGFX_TOOLS_PREFIX" "bgfx-")
    (lib.cmakeFeature "MESHOPTIMIZER_LIBRARIES" "${lib.getLib meshoptimizer}/lib/libmeshoptimizer${stdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeFeature "MESHOPTIMIZER_INCLUDE_DIR" "${lib.getDev meshoptimizer}/include")
    (lib.cmakeBool "BGFX_CUSTOM_TARGETS" false)
  ];

  # Keep notices for the statically linked bx, bimg and bundled third-party code.
  postInstall = ''
    (
      cd "$src"
      install -Dm644 LICENSE $out/share/licenses/bgfx/bgfx.cmake/LICENSE
      find bgfx bx bimg -type f \( \
        -iname 'license*' -o -iname 'copying*' -o -iname 'notice*' -o -iname 'unlicense*' \
      \) -exec install -Dm644 {} $out/share/licenses/bgfx/{} \;
    )
  '';

  # Check that an installed CMake consumer can link and run the Noop renderer.
  passthru.tests.consumer = callPackage ./test.nix {
    bgfx = finalAttrs.finalPackage;
  };

  meta = {
    description = "Cross-platform rendering library with multiple graphics backends";
    homepage = "https://github.com/bkaradzic/bgfx";
    license = with lib.licenses; [
      bsd2
      bsd3
      asl20
      mit
      isc # l-smash, linked into texturev
      zlib # lodepng and nanosvg, embedded in bimg_decode
      cc0
    ];
    maintainers = [ lib.maintainers.uuxyz ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "bgfx-shaderc";
    outputsToInstall = [
      "out"
      "bin"
    ];
  };
})
