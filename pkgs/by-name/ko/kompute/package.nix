{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  vulkan-headers,
  vulkan-loader,
  fmt_10,
  spdlog,
  glslang,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "kompute";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "KomputeProject";
    repo = "kompute";
    rev = "v${version}";
    hash = "sha256-cf9Ef85R+VKao286+WHLgBWUqgwvuRocgeCzVJOGbdc=";
  };

  cmakeFlags = [
    "-DKOMPUTE_OPT_USE_SPDLOG=ON"
    # Doesn’t work without the vendored `spdlog`, and is redundant.
    "-DKOMPUTE_OPT_LOG_LEVEL_DISABLED=ON"
    "-DKOMPUTE_OPT_USE_BUILT_IN_SPDLOG=OFF"
    "-DKOMPUTE_OPT_USE_BUILT_IN_FMT=OFF"
    "-DKOMPUTE_OPT_USE_BUILT_IN_GOOGLE_TEST=OFF"
    "-DKOMPUTE_OPT_USE_BUILT_IN_PYBIND11=OFF"
    "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=OFF"
    "-DKOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK=ON"
    "-DKOMPUTE_OPT_INSTALL=1"
  ];

  patches = [
    # FIXME: remove next update
    (fetchpatch {
      name = "vulkan-14-support.patch";
      url = "https://github.com/KomputeProject/kompute/commit/299b11fb4b8a7607c5d2c27e2735f26b06ae8e29.patch";
      sha256 = "sha256-JuoTQ+VjIdyF+I1IcT1ofbBjRS0Ibm2w6F2jrRJlx40=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    fmt_10
    spdlog
  ];
  propagatedBuildInputs = [
    glslang
    vulkan-headers
    vulkan-loader
  ];

  meta = with lib; {
    description = "General purpose GPU compute framework built on Vulkan";
    longDescription = ''
      General purpose GPU compute framework built on Vulkan to
      support 1000s of cross vendor graphics cards (AMD,
      Qualcomm, NVIDIA & friends). Blazing fast, mobile-enabled,
      asynchronous and optimized for advanced GPU data
      processing usecases. Backed by the Linux Foundation"
    '';
    homepage = "https://kompute.cc/";
    license = licenses.asl20;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.linux;
  };
}
