{ lib, stdenv,  fetchFromGitHub, cmake, gperf
, file, ncurses, openssl, readline, sqlite, zlib
, AppKit, Cocoa, Foundation
}:

stdenv.mkDerivation rec {
  pname = "nchat";
  version = "4.13";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    rev = "v${version}";
    hash = "sha256-dWoKHT1S68DlmXvcFQxBrVkGnIl9GW7zUov7untne8w=";
  };

  postPatch = ''
    substituteInPlace lib/tgchat/ext/td/CMakeLists.txt \
      --replace-warn "get_git_head_revision" "#get_git_head_revision"
    substituteInPlace lib/tgchat/ext/td/td/telegram/Client.h \
      --replace-warn '#include "td/telegram/td_api.h"' ""
  '';

  nativeBuildInputs = [ cmake gperf ];

  buildInputs = [
    file # for libmagic
    ncurses
    openssl
    readline
    sqlite
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ AppKit Cocoa Foundation ];

  meta = with lib; {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    homepage = "https://github.com/d99kris/nchat";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
