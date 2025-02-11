{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  ncurses,
  libconfuse,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "bmon";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "1ilba872c09mnlvylslv4hqv6c9cz36l76q74rr99jvis1dg69gf";
  };

  # The source code defines `__unused__`, which is a reserved name
  # https://github.com/tgraf/bmon/issues/89
  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/6d1dd5e9c8fae608bd22f3ede21e576f29c6358c/net/bmon/files/patch-fix__unused.diff";
      extraPrefix = "";
      sha256 = "sha256-UYIiJZzipsx9a0xabrKfyj8TWNW7IM77oXnVnSPkQkc=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    libconfuse
  ] ++ lib.optional stdenv.hostPlatform.isLinux libnl;

  preConfigure = ''
    # Must be an absolute path
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  meta = with lib; {
    description = "Network bandwidth monitor";
    homepage = "https://github.com/tgraf/bmon";
    # Licensed unter BSD and MIT
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.BSD
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.MIT
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      bjornfor
      pSub
    ];
    mainProgram = "bmon";
  };
}
