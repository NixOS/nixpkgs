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

stdenv.mkDerivation rec {
  pname = "egl-wayland";
<<<<<<< HEAD
  version = "1.1.21";
=======
  version = "1.1.20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "egl-wayland";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-a98DzmzCG6DlLJ1HCl/LeD21Q7yyNbTce1poOoAnTjA=";
=======
    hash = "sha256-uexvXwLj7QEBht74gmqC1+/y37wC6F/fTtf5RNcK/Pw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hedning ];
=======
  meta = with lib; {
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
