{ lib, mkDerivation, fetchFromGitHub, qmake, cmake, pkg-config, miniupnpc, bzip2
, speex, libmicrohttpd, libxml2, libxslt, sqlcipher, rapidjson, libXScrnSaver
, qtbase, qtx11extras, qtmultimedia, libgnome-keyring3
}:

mkDerivation rec {
  pname = "retroshare";
  version = "0.6.7.2";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "v${version}";
    sha256 = "sha256-1A1YvOWIiWlP1JPUTg5Z/lxVGCBv4tCPf5sZdPogitU=";
    fetchSubmodules = true;
  };

  patches = [
    # The build normally tries to get git sub-modules during build
    # but we already have them checked out
    ./no-submodules.patch
  ];

  nativeBuildInputs = [ pkg-config qmake cmake ];
  buildInputs = [
    speex miniupnpc qtmultimedia qtx11extras qtbase libgnome-keyring3
    bzip2 libXScrnSaver libxml2 libxslt sqlcipher libmicrohttpd rapidjson
  ];

  qmakeFlags = [
    # LIBSAM3 does not compile, so i2p support is broken
    # https://github.com/RetroShare/RetroShare/issues/2811 might be related
    "CONFIG+=no_rs_sam3"
    "CONFIG+=no_rs_sam3_libsam3"

    # Upnp library autodetection doesn't work
    "RS_UPNP_LIB=miniupnpc"

    # These values are normally found from the .git folder
    "RS_MAJOR_VERSION=${lib.versions.major version}"
    "RS_MINOR_VERSION=${lib.versions.minor version}"
    "RS_MINI_VERSION=${lib.versions.patch version}"
    "RS_EXTRA_VERSION=.2"
  ];

  postInstall = ''
    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = with lib; {
    description = "Decentralized peer to peer chat application.";
    homepage = "https://retroshare.cc/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
