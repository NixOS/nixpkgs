{
  lib,
  fetchFromGitHub,
  file, # for libmagic
  ncurses,
  openssl,
  readline,
  sqlite,
  zlib,
  cmake,
  gperf,
  stdenv,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "nchat";
  version = "5.3.5";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    rev = "refs/tags/v${version}";
    hash = "sha256-Nnu2Bk11Crk2vhvQqlDFo42duDqkNRCwDq4xCKIXwLQ=";
  };

  postPatch = ''
    substituteInPlace lib/tgchat/ext/td/CMakeLists.txt \
      --replace "get_git_head_revision" "#get_git_head_revision"
    substituteInPlace lib/tgchat/CMakeLists.txt \
      --replace-fail "list(APPEND OPENSSL_ROOT_DIR" "#list(APPEND OPENSSL_ROOT_DIR"
  '';

  nativeBuildInputs = [
    cmake
    gperf
  ];

  buildInputs =
    [
      file # for libmagic
      ncurses
      openssl
      readline
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        Cocoa
        Foundation
      ]
    );

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DHAS_WHATSAPP=OFF" # go module build required
  ];

  meta = {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    changelog = "https://github.com/d99kris/nchat/releases/tag/v${version}";
    homepage = "https://github.com/d99kris/nchat";
    license = lib.licenses.mit;
    mainProgram = "nchat";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sikmir
    ];
    platforms = lib.platforms.unix;
  };
}
