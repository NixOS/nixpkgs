{
  lib,
  stdenv,
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  installShellFiles,
  libtool,
  libtorrent-rakshasa,
  ncurses,
  openssl,
  pkg-config,
  zlib,
  nixosTests,
  gitUpdater,
  withLua ? false,
  lua5_4_compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtorrent";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+lpivm3MXbuJ4XYhK5OaASpqpDKcCdW7JCFjQYBYCSA=";
  };

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    inherit libtorrent-rakshasa;
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    cppunit
    curl
    libtool
    libtorrent-rakshasa
    ncurses
    openssl
    zlib
  ]
  ++ lib.optionals withLua [ lua5_4_compat ];

  configureFlags = [
    "--with-xmlrpc-tinyxml2"
    "--with-posix-fallocate"
  ]
  ++ lib.optionals withLua [ "--with-lua" ];

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
})
