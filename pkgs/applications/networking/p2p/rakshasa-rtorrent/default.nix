{ lib
, stdenv
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
  version = "0.9.8+date=2022-06-20";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "92bec88d0904bfb31c808085c2fd0f22d0ec8db7";
    hash = "sha256-er7UdIb+flhq0ye76UmomgfHV2ZSBROpXmfrNDHwTWw=";
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
    description = "Ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ebzzry codyopel ];
    platforms = platforms.unix;
    mainProgram = "rtorrent";
  };
}
