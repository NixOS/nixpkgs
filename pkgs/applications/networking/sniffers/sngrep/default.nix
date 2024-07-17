{ lib
, stdenv
, autoconf
, automake
, fetchFromGitHub
, libpcap
, ncurses
, openssl
, pcre
}:

stdenv.mkDerivation rec {
  pname = "sngrep";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nvuT//FWJAa6DzmjBsBW9s2p1M+6Zs4cVmpK4dVemnE=";
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
    description = "Tool for displaying SIP calls message flows from terminal";
    mainProgram = "sngrep";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
