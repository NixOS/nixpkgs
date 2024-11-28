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
  apple-sdk_11,
  darwinMinVersionHook,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "scopehal-apps";
  version = "0-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "ngscopeclient";
    repo = "scopehal-apps";
    rev = "d2a1a2f17e9398a3f60c99483dd2f6dbc2e62efc";
    hash = "sha256-FQoaTuL6mEqnH8oNXwHpDcOEAPGExqj6lhrUhZ9VAQ4=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      pkg-config
      shaderc
      spirv-tools
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook4
    ];

  buildInputs =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      ffts
      gtkmm3
      libtirpc
    ]
    ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "10.15")
      moltenvk
    ];

  # Targets InitializeSearchPaths
  postPatch = ''
    substituteInPlace lib/scopehal/scopehal.cpp \
      --replace-fail '"/share/' '"/../share/'
  '';

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
