{
  lib,
  stdenv,
  fetchFromGitHub,
  libglut,
  libGL,
  libGLU,
  libx11,
  libxext,
  libxi,
  libxmu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glui";
  version = "2.37";

  src = fetchFromGitHub {
    owner = "libglui";
    repo = "glui";
    rev = finalAttrs.version;
    hash = "sha256-EZixuhYCgl5x0Dmfymei5tHe8UUaaxy8+gPokjjy4mE=";
  };

  buildInputs = [
    libglut
    libGLU
    libGL
    libxmu
    libxext
    libx11
    libxi
  ];

  installPhase = ''
    mkdir -p "$out"/{bin,lib,share/glui/doc,include}
    cp -rT bin "$out/bin"
    cp -rT lib "$out/lib"
    cp -rT include "$out/include"
    cp -rT doc "$out/share/glui/doc"
    cp LICENSE.txt "$out/share/glui/doc"
  '';

  meta = {
    description = "User interface library using OpenGL";
    homepage = "https://github.com/libglui/glui";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
})
