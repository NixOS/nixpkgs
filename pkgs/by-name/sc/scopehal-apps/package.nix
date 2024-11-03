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
}:

stdenv.mkDerivation rec {
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

  nativeBuildInputs = [
    cmake
    pkg-config
    shaderc
    spirv-tools
    wrapGAppsHook4
  ];

  buildInputs = [
    cairomm
    ffts
    glew
    glfw
    glslang
    gtkmm3
    liblxi
    libsigcxx
    libtirpc
    vulkan-headers
    vulkan-loader
    vulkan-tools
    yaml-cpp
    zstd
  ];

  # Targets InitializeSearchPaths
  postPatch = ''
    substituteInPlace lib/scopehal/scopehal.cpp \
      --replace-fail '"/share/' '"/../share/'
  '';

  meta = {
    description = "Advanced test & measurement remote control and analysis suite";
    homepage = "https://www.ngscopeclient.org/";
    license = lib.licenses.bsd3;
    mainProgram = "ngscopeclient";
    maintainers = with lib.maintainers; [ bgamari ];
    platforms = lib.platforms.linux;
  };
}
