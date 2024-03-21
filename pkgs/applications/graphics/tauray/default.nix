{ lib
, stdenv
, fetchFromGitHub
, cmake
, graphviz
, doxygen
, pkg-config
, python3
, libcbor
, czmq
, glm
, nng
, mbedtls
, openxr-loader
, SDL2
, shaderc
, spirv-headers
, vulkan-headers
, vulkan-loader
, wayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tauray";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "vga-group";
    repo = "tauray";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Q3Dv96iptDvmBp9mIVSYzb7EnIzD1kFejwrFuc1HqdU=";
    fetchSubmodules = true;
  };

  buildInputs = [
    czmq
    glm
    libcbor
    nng
    mbedtls
    openxr-loader
    (SDL2.override { withStatic = true; })
    vulkan-loader
    wayland
  ];

  nativeBuildInputs = [
    cmake
    graphviz
    doxygen
    pkg-config
    python3
    shaderc
    vulkan-headers
  ];

  meta = with lib; {
    description = "A real-time rendering framework, with a focus on distributed computing, scalability, portability and low latency";
    homepage = "https://github.com/vga-group/tauray";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})

