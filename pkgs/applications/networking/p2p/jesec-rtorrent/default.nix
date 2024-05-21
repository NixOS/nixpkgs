{ lib
, stdenv
, fetchFromGitHub
, cmake
, curl
, gtest
, libtorrent
, ncurses
, jsonRpcSupport ? true, nlohmann_json
, xmlRpcSupport ? true, xmlrpc_c
}:

stdenv.mkDerivation rec {
  pname = "jesec-rtorrent";
  version = "0.9.8-r16";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "rtorrent";
    rev = "v${version}";
    hash = "sha256-i7c1jSawHshj1kaXl8tdpelIKU24okeg9K5/+ht6t2k=";
  };

  patches = [
    ./avoid-stack-overflow-for-lockfile-buf.patch
  ];

  passthru = {
    inherit libtorrent;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    curl
    libtorrent
    ncurses
  ]
  ++ lib.optional jsonRpcSupport nlohmann_json
  ++ lib.optional xmlRpcSupport xmlrpc_c;

  cmakeFlags = [
    "-DUSE_RUNTIME_CA_DETECTION=NO"
  ]
  ++ lib.optional (!jsonRpcSupport) "-DUSE_JSONRPC=NO"
  ++ lib.optional (!xmlRpcSupport) "-DUSE_XMLRPC=NO";

  doCheck = true;

  nativeCheckInputs = [
    gtest
  ];

  prePatch = ''
    substituteInPlace src/main.cc \
      --replace "/etc/rtorrent/rtorrent.rc" "${placeholder "out"}/etc/rtorrent/rtorrent.rc"
  '';

  postFixup = ''
    mkdir -p $out/etc/rtorrent
    cp $src/doc/rtorrent.rc $out/etc/rtorrent/rtorrent.rc
  '';

  meta = with lib; {
    description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach (jesec's fork)";
    homepage = "https://github.com/jesec/rtorrent";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winter AndersonTorres ];
    platforms = platforms.linux;
    mainProgram = "rtorrent";
  };
}
