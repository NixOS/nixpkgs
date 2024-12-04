{ lib
, stdenv
, fetchurl
, curl
, gmp
, gsl
, mpfr
, ncurses
, plotutils
, postgresql
, pkg-config
, withPDFDoc ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "algol68g";
  version = "3.4.2";

  src = fetchurl {
    url = "https://jmvdveer.home.xs4all.nl/algol68g-${finalAttrs.version}.tar.gz";
    hash = "sha256-hKiRMU98sZhGgHhjgtwUNSIv2iPgb4T+dgYw58IGK8Q=";
  };

  outputs = [ "out" "man" ] ++ lib.optionals withPDFDoc [ "doc" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    mpfr
    ncurses
    gmp
    gsl
    plotutils
    postgresql
  ];

  strictDeps = true;

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
    mainProgram = "a68g";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
