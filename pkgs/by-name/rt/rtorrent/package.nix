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
  xmlrpc_c,
  zlib,
  nixosTests,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-rtorrent";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "v${version}";
    hash = "sha256-G/30Enycpqg/pWC95CzT9LY99kN4tI+S8aSQhnQO+M8=";
  };

  patches = [
    # fix: use fsync for osx builds
    (fetchpatch {
      url = "https://github.com/rakshasa/rtorrent/commit/5ce84929e44fbe3f8d6cf142e3133f43afa4071f.patch";
      hash = "sha256-bFDxbpkTZ6nIUT2zMxKMgV94vWlVNzBbIbhx4Bpr8gw=";
    })
  ];

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
    xmlrpc_c
    zlib
  ];

  configureFlags = [
    "--with-xmlrpc-c"
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
