{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  meson,
  ninja,
  wayland-scanner,
  libjpeg,
  libpng,
  libx11,
  libGL,
  libdrm,
  udev,
  wayland,
  wayland-protocols,
  libgbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glmark2";
  version = "2023.01";

  src = fetchFromGitHub {
    owner = "glmark2";
    repo = "glmark2";
    rev = finalAttrs.version;
    sha256 = "sha256-WCvc5GqrAdpIKQ4LVqwO6ZGbzBgLCl49NxiGJynIjSQ=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    libjpeg
    libpng
    libx11
    libdrm
    udev
    wayland
    wayland-protocols
    libgbm
  ];

  mesonFlags = [
    "-Dflavors=drm-gl,drm-glesv2,gbm-gl,gbm-glesv2,wayland-gl,wayland-glesv2,x11-gl,x11-gl-egl,x11-glesv2"
  ];

  postInstall = ''
    for binary in $out/bin/glmark2*; do
      wrapProgram $binary \
        --prefix LD_LIBRARY_PATH ":" ${libGL}/lib
    done
  '';

  meta = {
    description = "OpenGL (ES) 2.0 benchmark";
    homepage = "https://github.com/glmark2/glmark2";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      glmark2 is a benchmark for OpenGL (ES) 2.0. It uses only the subset of
      the OpenGL 2.0 API that is compatible with OpenGL ES 2.0.
    '';
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wmertens ];
  };
})
