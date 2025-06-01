{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  lcms2,
  libGL,
  libX11,
  libunwind,
  libdovi,
  xxHash,
  fast-float,
  vulkanSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "libplacebo";
  version = "7.351.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libplacebo";
    rev = "v${version}";
    hash = "sha256-ccoEFpp6tOFdrfMyE0JNKKMAdN4Q95tP7j7vzUj+lSQ=";
  };

  patches = [
    # Breaks mpv vulkan shaders:
    #   https://code.videolan.org/videolan/libplacebo/-/issues/335
    (fetchpatch {
      name = "fix-shaders.patch";
      url = "https://github.com/haasn/libplacebo/commit/4c6d99edee23284f93b07f0f045cd660327465eb.patch";
      revert = true;
      hash = "sha256-zoCgd9POlhFTEOzQmSHFZmJXgO8Zg/f9LtSTSQq5nUA=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.jinja2
    python3Packages.glad2
  ];

  buildInputs =
    [
      shaderc
      lcms2
      libGL
      libX11
      libunwind
      libdovi
      xxHash
      vulkan-headers
    ]
    ++ lib.optionals vulkanSupport [
      vulkan-loader
    ]
    ++ lib.optionals (!stdenv.cc.isGNU) [
      fast-float
    ];

  mesonFlags =
    [
      (lib.mesonBool "demos" false) # Don't build and install the demo programs
      (lib.mesonEnable "d3d11" false) # Disable the Direct3D 11 based renderer
      (lib.mesonEnable "glslang" false) # rely on shaderc for GLSL compilation instead
      (lib.mesonEnable "vk-proc-addr" vulkanSupport)
      (lib.mesonOption "vulkan-registry" "${vulkan-headers}/share/vulkan/registry/vk.xml")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.mesonEnable "unwind" false) # libplacebo doesn’t build with `darwin.libunwind`
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace 'python_env.append' '#'
  '';

  meta = with lib; {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    longDescription = ''
      Reusable library for GPU-accelerated image/view processing primitives and
      shaders, as well a batteries-included, extensible, high-quality rendering
      pipeline (similar to mpv's vo_gpu). Supports Vulkan, OpenGL and Metal (via
      MoltenVK).
    '';
    homepage = "https://code.videolan.org/videolan/libplacebo";
    changelog = "https://code.videolan.org/videolan/libplacebo/-/tags/v${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.all;
  };
}
