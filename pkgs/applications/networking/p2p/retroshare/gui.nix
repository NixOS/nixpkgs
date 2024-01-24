{ lib
, mkDerivation
, callPackage
, cmake
, qmake
, doxygen
, pkg-config
, bzip2
, libXScrnSaver
, libzip
, miniupnpc
, openssl
, qtx11extras
, qtmultimedia
, rapidjson
, sqlcipher
, xapian
, friendServer ? false # Mostly a standalone program requiring tor
}:
let
  common = callPackage ./common.nix { };
in
mkDerivation rec {
  pname = "retroshare-gui";

  inherit (common) version src;

  patches = [
    # The build normally tries to get git sub-modules during build
    # but we already have them checked out
    ./no-submodules.patch
  ];

  nativeBuildInputs = [ pkg-config qmake cmake doxygen ];
  buildInputs = [
    bzip2
    libXScrnSaver
    libzip
    miniupnpc
    openssl
    qtmultimedia
    qtx11extras
    rapidjson
    sqlcipher
    xapian
  ];

  qmakeFlags = common.RSVersionFlags ++ [
    # LIBSAM3 does not compile, so i2p support is broken
    # https://github.com/RetroShare/RetroShare/issues/2811 might be related
    "CONFIG+=no_rs_sam3"
    "CONFIG+=no_rs_sam3_libsam3"

    "CONFIG-=debug"
    "CONFIG+=release"

    # Enable ipv6 support
    "CONFIG+=ipv6"

    # Embedded friendserver
    "CONFIG+=rs_efs"

    # Webui
    "CONFIG+=rs_webui"
    "CONFIG+=rs_jsonapi"

        # This is a separate program better built with cmake
    "CONFIG+=no_retroshare_service"

    # Upnp library autodetection doesn't work
    "RS_UPNP_LIB=miniupnpc"
  ] ++ lib.optionals (!friendServer) [
    "CONFIG+=no_retroshare_friendserver"
  ];

  meta = with lib; {
    description = "Decentralized peer to peer chat application.";
    homepage = "https://retroshare.cc/";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW dandellion ];
  };
}
