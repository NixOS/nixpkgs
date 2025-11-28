{
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  installShellFiles,
  lib,
  libtool,
  libtorrent-rakshasa,
  lua5_4_compat,
  ncurses,
  nixosTests,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
  versionCheckHook,
  withLua ? false,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtorrent";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ut1R73UfkpDk/Y5Fq8kSavxIB3Y2jbYEQ8J/559Ech0=";
  };

  outputs = [
    "out"
    "man"
  ];

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

  enableParallelBuilding = true;

  postInstall = ''
    installManPage doc/old/rtorrent.1
    install -Dm644 doc/rtorrent.rc-example -t $out/share/doc/rtorrent/rtorrent.rc
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-h";

  passthru = {
    inherit libtorrent-rakshasa;
    tests = { inherit (nixosTests) rtorrent; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    homepage = "https://rakshasa.github.io/rtorrent/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "rtorrent";
    maintainers = with lib.maintainers; [
      ebzzry
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})
