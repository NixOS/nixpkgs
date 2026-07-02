{
  _experimental-update-script-combinators,
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
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  withLua ? false,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtorrent";
  version = "0.16.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OEIJMBj1UfIOpR1w8c8ztKWJVD5hKxiJaxweF7mBRNM=";
  };

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    pkg-config
    writableTmpDirAsHomeHook
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
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    inherit libtorrent-rakshasa;
    tests = { inherit (nixosTests) rtorrent; };
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { attrPath = "libtorrent-rakshasa"; })
      (nix-update-script { })
    ];
  };

  meta = {
    description = "Ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    homepage = "https://rakshasa.github.io/rtorrent/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "rtorrent";
    maintainers = with lib.maintainers; [
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})
