{ lib, stdenv,  fetchFromGitHub, cmake, gperf
, file, ncurses, openssl, readline, sqlite, zlib
, AppKit, Cocoa, Foundation
}:

stdenv.mkDerivation rec {
  pname = "nchat";
  version = "3.67";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    rev = "v${version}";
    hash = "sha256-PhvZejtSoDptzoMP5uIe6T0Ws/bQQXVuYH9uoZo3JsI=";
  };

  postPatch = ''
    substituteInPlace lib/tgchat/ext/td/CMakeLists.txt \
      --replace "get_git_head_revision" "#get_git_head_revision"
  '';

  nativeBuildInputs = [ cmake gperf ];

  buildInputs = [
    file # for libmagic
    ncurses
    openssl
    readline
    sqlite
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit Cocoa Foundation ];

  cmakeFlags = [
    "-DHAS_WHATSAPP=OFF" # go module build required
  ];

  meta = with lib; {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    mainProgram = "nchat";
    homepage = "https://github.com/d99kris/nchat";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
