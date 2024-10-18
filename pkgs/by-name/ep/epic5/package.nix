{
  lib,
  stdenv,
  ruby,
  fetchurl,
  openssl,
  ncurses,
  libiconv,
  tcl,
  coreutils,
  fetchpatch,
  libxcrypt,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epic5";
  version = "3.0";

  src = fetchurl {
    url = "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-${finalAttrs.version}.tar.xz";
    hash = "sha256-ltRzUME6PZkBnaDmoEsMf4Datt26WQvMZ527iswXeaE=";
  };

  # Darwin needs libiconv, tcl; while Linux build don't
  buildInputs =
    [
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
    homepage = "http://epicsol.org";
    description = "IRC client that offers a great ircII interface";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platform = lib.platforms.unix;
    mainProgram = "epic5";
  };
})
