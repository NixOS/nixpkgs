{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, cppunit
, curl
, libsigcxx
, libtool
, libtorrent
, ncurses
, openssl
, pkg-config
, xmlrpc_c
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-rtorrent";
  version = "0.9.8+date=2021-08-07";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "a6bc99bb821d86b3b0633552db3fbd0a22497657";
    hash = "sha256-HTwAs8dfZVXfLRNiT6QpjKGnuahHfoMfYWqdKkedUL0=";
  };

  passthru = {
    inherit libtorrent;
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cppunit
    curl
    libsigcxx
    libtool
    libtorrent
    ncurses
    openssl
    xmlrpc_c
    zlib
  ];

  configureFlags = [
    "--with-xmlrpc-c"
    "--with-posix-fallocate"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/man/man1 $out/share/doc/rtorrent
    mv doc/old/rtorrent.1 $out/share/man/man1/rtorrent.1
    mv doc/rtorrent.rc $out/share/doc/rtorrent/rtorrent.rc
  '';

  meta = with lib; {
    homepage = "https://rakshasa.github.io/rtorrent/";
    description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ebzzry codyopel ];
    platforms = platforms.unix;
    mainProgram = "rtorrent";
  };
}
