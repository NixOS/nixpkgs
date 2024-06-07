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
  version = "4.86";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    rev = "refs/tags/v${version}";
    hash = "sha256-ju9FabCxh/OvEFZee6ZzJEG5RpaCwR297SFk7leKnhA=";
  };

  postPatch = ''
    substituteInPlace lib/tgchat/ext/td/CMakeLists.txt \
      --replace "get_git_head_revision" "#get_git_head_revision"
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
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        Cocoa
        Foundation
      ]
    );

  cmakeFlags = [
    "-DHAS_WHATSAPP=OFF" # go module build required
  ];

  meta = with lib; {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    changelog = "https://github.com/d99kris/nchat/releases/tag/v${version}";
    homepage = "https://github.com/d99kris/nchat";
    license = licenses.mit;
    mainProgram = "nchat";
    maintainers = with maintainers; [
      luftmensch-luftmensch
      sikmir
    ];
    platforms = platforms.unix;
  };
}
