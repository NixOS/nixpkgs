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
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-rtorrent";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "68fdb86c723a0ae67ebaffec416af99fec41dcbc";
    hash = "sha256-/GWC28LsY7GcUH+SBzi01sOWVfA1lyM0r9OdUDTYbT8=";
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
    updateScript = gitUpdater { rev-prefix = "v"; };
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
