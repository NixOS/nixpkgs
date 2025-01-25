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
    repo = pname;
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

  meta = with lib; {
    description = "scd2html generates HTML from scdoc source files";
    homepage = "https://git.sr.ht/~bitfehler/scd2html";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "scd2html";
  };
}
