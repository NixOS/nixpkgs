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
  version = "0.10.0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "b8cb828d963719565528573123bb08b72cd50928";
    hash = "sha256-nvyRRmZRdyRAazGAFqHDK+zME9bSkp+LwW9Na4M8+L0=";
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
    maintainers = with lib.maintainers; [
      ebzzry
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
    mainProgram = "rtorrent";
  };
}
