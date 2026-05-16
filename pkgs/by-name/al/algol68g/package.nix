{
  lib,
  stdenv,
  fetchurl,
  curl,
  gmp,
  gsl,
  libpq,
  mpfr,
  ncurses,
  plotutils,
  pkg-config,
  withPDFDoc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "algol68g";
  version = "3.12.0";

  src = fetchurl {
    # Uses archive.org because the original site removes older versions.
    url = "https://web.archive.org/web/20260503173638/https://algol68genie.nl/algol68g-3.12.0.tar.gz";
    hash = "sha256-fYjuivr6AKRK4Nn45Q+oglpTMnp+PhO6KOkGZjwVKn0=";
  };

  outputs = [
    "out"
    "man"
  ]
  ++ lib.optionals withPDFDoc [ "doc" ];

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
    libpq
  ];

  strictDeps = true;

  postInstall =
    let
      pdfdoc = fetchurl {
        url = "https://web.archive.org/web/20260503174213/https://algol68genie.nl/learning-algol-68-genie.pdf";
        hash = "sha256-eLMRf3XcAkr/Dmk7ieRe62x76VcCj+2QltHH7YtL15s=";
      };
    in
    lib.optionalString withPDFDoc ''
      install -m644 ${pdfdoc} ${placeholder "doc"}/share/doc/algol68g/learning-algol-68-genie.pdf
    '';

  meta = {
    homepage = "https://algol68genie.nl/en/algol-68-genie/";
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
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.unix;
  };
})
