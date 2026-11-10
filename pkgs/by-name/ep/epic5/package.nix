{
  lib,
  stdenv,
  ruby,
  fetchurl,
  openssl,
  ncurses,
  libiconv,
  tcl,
  libxcrypt,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epic5";
  version = "3.0.3";

  src = fetchurl {
    url = "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y6QRIVwUBAtltdcor/EPdSPVXhcPYpj7AeHPlY150yY=";
  };

  buildInputs = [
    openssl
    ncurses
    libxcrypt
    ruby
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    tcl
  ];

  configureFlags = [
    "--with-ipv6"
  ];

  nativeBuildInputs = [
    perl
  ];

  meta = {
    homepage = "https://epicsol.org";
    description = "IRC client that offers a great ircII interface";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    mainProgram = "epic5";
  };
})
