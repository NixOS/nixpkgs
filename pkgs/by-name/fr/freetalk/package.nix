{
  lib,
  stdenv,
  fetchurl,
  guile,
  pkg-config,
  glib,
  loudmouth,
  gmp,
  libidn,
  readline,
  libtool,
  libunwind,
  ncurses,
  curl,
  jansson,
  texinfo,
  argp-standalone,
}:
stdenv.mkDerivation rec {
  pname = "freetalk";
  version = "4.2";

  src = fetchurl {
    url = "mirror://gnu/freetalk/freetalk-${version}.tar.gz";
    hash = "sha256-u1tPKacGry+JGYeAIgDia3N7zs5EM4FyQZdV8e7htYA=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    glib
    loudmouth
    gmp
    libidn
    readline
    libtool
    libunwind
    ncurses
    curl
    jansson
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    argp-standalone
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-largp";

<<<<<<< HEAD
  meta = {
    description = "Console XMPP client";
    mainProgram = "freetalk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Console XMPP client";
    mainProgram = "freetalk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    downloadPage = "https://www.gnu.org/software/freetalk/";
  };
}
