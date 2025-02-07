{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  vulkan-headers,
  vulkan-loader,
}:
stdenv.mkDerivation {
  pname = "monado-vulkan-layers";
  version = "0-unstable-2024-02-21";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "utilities/vulkan-layers";
    rev = "ae43cdcbd25c56e3481bbc8a0ce2bfcebba9f7c2";
    sha256 = "sha256-QabYVKcenW+LQ+QSjUoQOLOQAVHdjE0YXd+1WsdzNPc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  patches = [
    ./absolute-layer-path.patch
  ];

  meta = with lib; {
    description = "Vulkan Layers for Monado";
    homepage = "https://gitlab.freedesktop.org/monado/utilities/vulkan-layers";
    platforms = platforms.linux;
    license = licenses.boost;
    maintainers = with maintainers; [
      Scrumplex
      passivelemon
    ];
  };
}
