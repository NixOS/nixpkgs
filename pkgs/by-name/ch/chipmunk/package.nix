{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  libglut,
  libGLU,
  libGL,
  glfw2,
  glew,
  libx11,
  xorgproto,
  libxi,
  libxmu,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chipmunk";
  version = "7.0.3-unstable-2026-01-08";

  src = fetchFromCodeberg {
    owner = "slembcke";
    repo = "Chipmunk2D";
    rev = "5b45034a8761518800e03dd79f33c3aad0bf7fee";
    hash = "sha256-y8mTV2ZN1s3vLGwv0mlL3gsYRDHHw5DWQctlKg52WEk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libglut
    libGLU
    libGL
    glfw2
    glew
    libx11
    xorgproto
    libxi
    libxmu
    libxrandr
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp demo/chipmunk_demos $out/bin
  '';

  meta = {
    description = "Fast and lightweight 2D game physics library";
    mainProgram = "chipmunk_demos";
    homepage = "https://codeberg.org/slembcke/Chipmunk2D";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix; # supports Windows and MacOS as well, but those require more work
  };
})
