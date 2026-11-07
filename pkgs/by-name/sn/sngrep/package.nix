{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  libgcrypt,
  libpcap,
  ncurses,
  openssl,
  pcre2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sngrep";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = "sngrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g+YHa69CJNndWqmtLSH6K0U1QOG5AQLxDPoApZXfhKE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    libpcap
    ncurses
    openssl
    pcre2
  ];

  configureFlags = [
    "--with-pcre2"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
    "--with-openssl"
  ];

  patches = [
    ./fix-sng_strncpy-declaration.patch
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  doCheck = true;

  meta = {
    description = "Tool for displaying SIP calls message flows from terminal";
    mainProgram = "sngrep";
    homepage = "https://github.com/irontec/sngrep";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jorise ];
  };
})
