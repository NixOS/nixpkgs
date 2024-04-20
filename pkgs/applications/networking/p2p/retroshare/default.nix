{ lib, mkDerivation, fetchFromGitHub
, fetchpatch
, qmake, cmake, pkg-config, miniupnpc, bzip2
, speex, libmicrohttpd, libxml2, libxslt, sqlcipher, rapidjson, libXScrnSaver
, qtbase, qtx11extras, qtmultimedia, libgnome-keyring3
}:

mkDerivation rec {
  pname = "retroshare";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "v${version}";
    sha256 = "1hsymbhsfgycj39mdkrdp2hgq8irmvxa4a6jx2gg339m1fgf2xmh";
    fetchSubmodules = true;
  };

  patches = [
    # The build normally tries to get git sub-modules during build
    # but we already have them checked out
    ./no-submodules.patch
    ./cpp-filesystem.patch

    # Fix gcc-13 build failure
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/RetroShare/RetroShare/commit/e1934fd9b03cd52c556eb06d94fb5d68b649592e.patch";
      hash = "sha256-oqxQAsD4fmkWAH2kSVmmed/q0LzTW/iqUU1SgYNdFyk=";
    })
  ];

  nativeBuildInputs = [ pkg-config qmake cmake ];
  buildInputs = [
    speex miniupnpc qtmultimedia qtx11extras qtbase libgnome-keyring3
    bzip2 libXScrnSaver libxml2 libxslt sqlcipher libmicrohttpd rapidjson
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
