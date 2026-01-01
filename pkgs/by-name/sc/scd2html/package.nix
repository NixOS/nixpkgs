{
  lib,
  stdenv,
  fetchFromSourcehut,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "scd2html";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = "scd2html";
    rev = "v${version}";
    hash = "sha256-oZSHv5n/WOrvy77tC94Z8pYugLpHkcv7U1PrzR+8fHM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    scdoc
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "LDFLAGS+=-static" "LDFLAGS+="
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Generates HTML from scdoc source files";
    homepage = "https://git.sr.ht/~bitfehler/scd2html";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Generates HTML from scdoc source files";
    homepage = "https://git.sr.ht/~bitfehler/scd2html";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "scd2html";
  };
}
