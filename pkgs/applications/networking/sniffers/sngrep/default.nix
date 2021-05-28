{ stdenv, autoconf, automake, fetchFromGitHub, libpcap, ncurses, openssl, pcre }:

stdenv.mkDerivation rec {
  pname = "sngrep";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dx5l48m4634y0zi6wjky412g80lfxqq1nphv7pi1kwvm1k5m5ri";
  };

  buildInputs = [
    libpcap ncurses pcre openssl ncurses
  ];

  nativeBuildInputs = [
    autoconf automake
  ];

  configureFlags = [
    "--with-pcre"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
  ];

  preConfigure = "./bootstrap.sh";

  meta = with stdenv.lib; {
    description = "A tool for displaying SIP calls message flows from terminal";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
