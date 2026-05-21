{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxext,
  libjpeg,
  libpng,
  giflib,
}:

stdenv.mkDerivation {
  pname = "meh";
  version = "unstable-2018-10-22";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "meh";
    rev = "69f653a1f16d11b12e5b600e808a740898f3223e";
    sha256 = "sha256-srSwoaajW4H4+kmE7NQAqVz9d/1q2XQ5ayQaOcGwzI0=";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [
    libxext
    libx11
    libjpeg
    libpng
    giflib
  ];

  meta = {
    description = "Minimal image viewer using raw XLib";
    homepage = "https://www.johnhawthorn.com/meh/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "meh";
  };
}
