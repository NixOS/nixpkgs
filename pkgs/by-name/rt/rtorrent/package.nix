{ lib
, stdenv
, autoconf-archive
, autoreconfHook
, cppunit
, curl
, fetchFromGitHub
, installShellFiles
, libsigcxx
, libtool
, libtorrent
, ncurses
, openssl
, pkg-config
, xmlrpc_c
, zlib
, nixosTests
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "rakshasa-rtorrent";
  version = "0.9.8-unstable-2024-08-09";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "892e595015404c125df4a836b2a4fa18c01b4586";
    hash = "sha256-y7VlpviWT4kq4sfeWq00qM40tBAyGFBAplwrji45dOc=";
  };

  outputs = [ "out" "man" ];

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
    xmlrpc_c
    zlib
  ];

  configureFlags = [
    "--with-xmlrpc-c"
    "--with-posix-fallocate"
  ];

  passthru = {
    updateScript = unstableGitUpdater { tagPrefix = "v"; };
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
    maintainers = with lib.maintainers; [ ebzzry codyopel thiagokokada ];
    platforms = lib.platforms.unix;
    mainProgram = "rtorrent";
  };
}
