{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  libX11,
  libdrm,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland";
  version = "1.1.21";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "egl-wayland";
    rev = finalAttrs.version;
    hash = "sha256-a98DzmzCG6DlLJ1HCl/LeD21Q7yyNbTce1poOoAnTjA=";
  };

  postPatch = ''
    # Declares an includedir but doesn't install any headers
    # CMake's `pkg_check_modules(NAME wayland-eglstream IMPORTED_TARGET)` considers this an error
    sed -i -e '/includedir/d' wayland-eglstream.pc.in
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libX11
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  meta = {
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hedning ];
  };
})
