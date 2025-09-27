{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  cairomm,
  yaml-cpp,
  glfw,
  libtirpc,
  liblxi,
  libsigcxx,
  glew,
  zstd,
  wrapGAppsHook4,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  glslang,
  spirv-tools,
  ffts,
  moltenvk,
  llvmPackages,
  hidapi,
}:

let
  pname = "scopehal-apps";
  version = "0.1";
in
stdenv.mkDerivation {
  pname = "${pname}";
  version = "${version}";

  src = fetchFromGitHub {
    owner = "ngscopeclient";
    repo = "${pname}";
    tag = "v${version}";
    hash = "sha256-AfO6JaWA9ECMI6FkMg/LaAG4QMeZmG9VxHiw0dSJYNM=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    shaderc
    spirv-tools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = [
    cairomm
    glew
    glfw
    glslang
    liblxi
    libsigcxx
    vulkan-headers
    vulkan-loader
    vulkan-tools
    yaml-cpp
    zstd
    hidapi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    ffts
    gtkmm3
    libtirpc
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_INSTALL_RPATH=${lib.strings.makeLibraryPath [ vulkan-loader ]}"
  ];

  meta = {
    description = "Advanced test & measurement remote control and analysis suite";
    homepage = "https://www.ngscopeclient.org/";
    license = lib.licenses.bsd3;
    mainProgram = "ngscopeclient";
    maintainers = with lib.maintainers; [
      bgamari
      carlossless
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
