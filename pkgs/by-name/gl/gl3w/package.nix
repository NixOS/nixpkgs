{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  libglvnd,
  libGLU,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gl3w";
  version = "0-unstable-2025-11-07";

  src = fetchFromGitHub {
    owner = "skaslev";
    repo = "gl3w";
    rev = "d5ba9340cdeb9154323817f5c87e5a5c377fdef7";
    hash = "sha256-IAI0Ep2s79UT2d8davHnUp65SvE5mubwqVg6ym1Agw4=";
  };

  nativeBuildInputs = [
    python3
    cmake
  ];
  # gl3w installs a CMake config that when included expects to be able to
  # build and link against both of these libraries
  # (the gl3w generated C file gets compiled into the downstream target)
  propagatedBuildInputs = [
    libglvnd
    libGLU
  ];

  dontUseCmakeBuildDir = true;

  # These files must be copied rather than linked since they are considered
  # outputs for the custom command, and CMake expects to be able to touch them
  preConfigure = ''
    mkdir -p include/{GL,KHR}
    cp ${libglvnd.dev}/include/GL/glcorearb.h include/GL/glcorearb.h
    cp ${libglvnd.dev}/include/KHR/khrplatform.h include/KHR/khrplatform.h
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Simple OpenGL core profile loading";
    homepage = "https://github.com/skaslev/gl3w";
    license = licenses.unlicense;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
