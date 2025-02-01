{
  stdenv,
  lib,
  meson,
  fetchFromGitHub,
  pkg-config,
  xorg,
  libGL,
  cairo,
  glslang,
  python3,
  doxygen,
  vulkan-loader,
  vulkan-headers,
  sphinx,
  sphinxygen,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pugl";
  version = "0-unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "lv2";
    repo = "pugl";
    rev = "edd13c1b952b16633861855fcdbdd164e87b3c0a";
    hash = "sha256-s7uvA3F16VxJgaKlQWQP9rQtzzlD1NuebIgR5L3yHw4=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    doxygen
    glslang
    sphinxygen
    sphinx
    python3.pkgs.sphinx-lv2-theme
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    libGL
    vulkan-loader
    vulkan-headers
    xorg.libXext
    cairo
  ];

  meta = {
    homepage = "https://github.com/lv2/pugl";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
    description = "Minimal portable API for embeddable GUIs";
  };
})
