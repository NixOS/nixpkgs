{ lib, stdenv,  fetchFromGitHub, cmake, gperf
, file, ncurses, openssl, readline, sqlite, zlib
, AppKit, Cocoa, Foundation
}:

stdenv.mkDerivation rec {
  pname = "nchat";
  version = "3.39";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    rev = "v${version}";
    hash = "sha256-ZV2vpXztvBDN66OPLpO/ezLB4+/3NOOs1Eky8uXxBbc=";
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
  ] ++ lib.optionals stdenv.isDarwin [ AppKit Cocoa Foundation ];

  cmakeFlags = [
    "-DHAS_WHATSAPP=OFF" # go module build required
  ];

  meta = with lib; {
    description = "Terminal-based chat client with support for Telegram and WhatsApp";
    homepage = "https://github.com/d99kris/nchat";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
