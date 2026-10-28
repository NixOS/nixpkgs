{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scd2html";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = "scd2html";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oZSHv5n/WOrvy77tC94Z8pYugLpHkcv7U1PrzR+8fHM=";
  };

  patches = [
    # gcc-16 fix
    (fetchpatch {
      name = "gcc-16.patch";
      url = "https://git.sr.ht/~bitfehler/scd2html/commit/7fd6434fe74dc08cb8cbd15b9bfc374a87ec0d11.patch";
      hash = "sha256-go4tfb44l89lATt6gWgiOx1z8H0Xe48eHiCV/lgTMVM=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    scdoc
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "LDFLAGS+=-static" "LDFLAGS+="
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Generates HTML from scdoc source files";
    homepage = "https://git.sr.ht/~bitfehler/scd2html";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "scd2html";
  };
})
