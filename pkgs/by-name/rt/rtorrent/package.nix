{
  lib,
  stdenv,
  autoconf-archive,
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  libsigcxx,
  libtool,
  libtorrent,
  ncurses,
  openssl,
  pkg-config,
  zlib,
  nixosTests,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-rtorrent";
  version = "0.10.0-unstable-2024-12-06";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "5a200f5d8f8bc8ed28dfc948321451585f724b15";
    hash = "sha256-RLFOHJLpt7xkrEvYwEBWs5wQRThrK1N2olI64p2TPeA=";
  };

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    inherit libtorrent;
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    installShellFiles
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
    zlib
  ];

  configureFlags = [
    "--with-xmlrpc-tinyxml2"
    "--with-posix-fallocate"
  ];

  passthru = {
    updateScript = unstableGitUpdater { rev-prefix = "v"; };
    tests = {
      inherit (nixosTests) rtorrent;
    };
  };

  enableParallelBuilding = true;

  postInstall = ''
    installManPage doc/old/rtorrent.1
    install -Dm644 doc/rtorrent.rc-example -t $out/share/doc/rtorrent/rtorrent.rc
  '';

  meta = {
    homepage = "https://rakshasa.github.io/rtorrent/";
    description = "Ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ebzzry
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
    mainProgram = "rtorrent";
  };
}
