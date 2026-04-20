{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  qmake,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  miniupnpc,
  bzip2,
  speex,
  libmicrohttpd,
  libxml2,
  libxslt,
  sqlcipher,
  rapidjson,
  libxscrnsaver,
  qtbase,
  qtx11extras,
  qtmultimedia,
  libgnome-keyring,
}:

stdenv.mkDerivation rec {
  pname = "retroshare";
  version = "0.6.7.2";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "v${version}";
    hash = "sha256-1A1YvOWIiWlP1JPUTg5Z/lxVGCBv4tCPf5sZdPogitU=";
    fetchSubmodules = true;
  };

  patches = [
    # The build normally tries to get git sub-modules during build
    # but we already have them checked out
    ./no-submodules.patch

    # Support the miniupnpc-2.2.8 API change
    (fetchpatch2 {
      url = "https://github.com/RetroShare/libretroshare/commit/f1b89c4f87d77714571b4135c301bf0429096a20.patch?full_index=1";
      hash = "sha256-UiZMsUFaOZTLj/dx1rLr5bTR1CQ6nt2+IygQdvwJqwc=";
      stripLen = 1;
      extraPrefix = "libretroshare/";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    qmake
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    speex
    miniupnpc
    qtmultimedia
    qtx11extras
    qtbase
    libgnome-keyring
    bzip2
    libxscrnsaver
    libxml2
    libxslt
    sqlcipher
    libmicrohttpd
    rapidjson
  ];

  qmakeFlags = [
    # Upnp library autodetection doesn't work
    "RS_UPNP_LIB=miniupnpc"

    # These values are normally found from the .git folder
    "RS_MAJOR_VERSION=${lib.versions.major version}"
    "RS_MINOR_VERSION=${lib.versions.minor version}"
    "RS_MINI_VERSION=${lib.versions.patch version}"
    "RS_EXTRA_VERSION="
  ];

  postPatch = ''
    # Build libsam3 as C, not C++. No, I have no idea why it tries to
    # do that, either.
    substituteInPlace libretroshare/src/libretroshare.pro \
      --replace-fail \
        "LIBSAM3_MAKE_PARAMS =" \
        "LIBSAM3_MAKE_PARAMS = CC=$CC AR=$AR"

    # openpgpsdk uses 'bool' as a variable name, which became a C23 keyword.
    # Rename it to avoid compile errors with GCC 14+ which defaults to c23.
    substituteInPlace openpgpsdk/src/openpgpsdk/packet-print.c \
      --replace-fail \
        "static void print_boolean(const char *name, unsigned char bool)" \
        "static void print_boolean(const char *name, unsigned char bool_val)" \
      --replace-fail "    if(bool)" "    if(bool_val)"
    # The C source inconsistently uses 'limited_read (bool,' (with a space) on line 1600
    substituteInPlace openpgpsdk/src/openpgpsdk/packet-parse.c \
      --replace-fail "unsigned char bool[1]=" 'unsigned char bool_val[1]=' \
      --replace-fail "limited_read(bool," "limited_read(bool_val," \
      --replace-fail "limited_read (bool," "limited_read (bool_val," \
      --replace-fail "!!bool[0]" "!!bool_val[0]"

    # Update cmake version for supportlibs to fix build with newer cmake
    substituteInPlace supportlibs/udp-discovery-cpp/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = {
    description = "Decentralized peer to peer chat application";
    homepage = "https://retroshare.cc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ StijnDW ];
  };
}
