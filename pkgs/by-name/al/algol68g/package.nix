{ lib
, stdenv
, fetchurl
, gsl
, plotutils
, postgresql
, withPDFDoc ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "algol68g";
  version = "3.3.23";

  src = fetchurl {
    url = "https://jmvdveer.home.xs4all.nl/algol68g-${finalAttrs.version}.tar.gz";
    hash = "sha256-NXSIm+Vl7/NT8ks0bNqWAIYlbtzGv0q0czxhGolF1bs=";
  };

  outputs = [ "out" "man" ] ++ lib.optional withPDFDoc "doc";

  buildInputs = [
    gsl
    plotutils
    postgresql
  ];

  postInstall = let
    pdfdoc = fetchurl {
      url = "https://jmvdveer.home.xs4all.nl/learning-algol-68-genie.pdf";
      hash = "sha256-QCwn1e/lVfTYTeolCFErvfMhvwCgsBnASqq2K+NYmlU=";
    };
  in lib.optionalString withPDFDoc
    ''
      install -m644 ${pdfdoc} ${placeholder "doc"}/share/doc/algol68g/learning-algol-68-genie.pdf
    '';

  meta = {
    homepage = "https://jmvdveer.home.xs4all.nl/en.algol-68-genie.html";
    description = "Algol 68 Genie compiler-interpreter";
    longDescription = ''
      Algol 68 Genie (a68g) is a recent checkout hybrid compiler-interpreter,
      written from scratch by Marcel van der Veer. It ranks among the most
      complete Algol 68 implementations. It implements for example arbitrary
      precision arithmetic, complex numbers, parallel processing, partial
      parametrisation and formatted transput, as well as support for curses,
      regular expressions and sounds. It can be linked to GNU plotutils, the GNU
      scientific library and PostgreSQL.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "a68g";
    platforms = lib.platforms.unix;
  };
})
