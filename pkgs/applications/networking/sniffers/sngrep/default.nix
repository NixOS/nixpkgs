{ lib
, stdenv
, autoconf
, automake
, fetchFromGitHub
, fetchpatch
, libpcap
, ncurses
, openssl
, pcre
}:

stdenv.mkDerivation rec {
  pname = "sngrep";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9ccp5Pxhs7jOQuWHCmU9yvzLKeOAN8lEaieCIvnXJRA=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    libpcap
    ncurses
    ncurses
    openssl
    pcre
  ];

  configureFlags = [
    "--with-pcre"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  doCheck = true;

  meta = with lib; {
    description = "A tool for displaying SIP calls message flows from terminal";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
