{ lib, mkDerivation, fetchFromGitHub, fetchpatch2
, qmake, cmake, pkg-config, miniupnpc, bzip2
, speex, libmicrohttpd, libxml2, libxslt, sqlcipher, rapidjson, libXScrnSaver
, qtbase, qtx11extras, qtmultimedia, libgnome-keyring
}:

mkDerivation rec {
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

  nativeBuildInputs = [ pkg-config qmake cmake ];
  buildInputs = [
    speex miniupnpc qtmultimedia qtx11extras qtbase libgnome-keyring
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

  postPatch = ''
    # Build libsam3 as C, not C++. No, I have no idea why it tries to
    # do that, either.
    substituteInPlace libretroshare/src/libretroshare.pro \
      --replace-fail \
        "LIBSAM3_MAKE_PARAMS =" \
        "LIBSAM3_MAKE_PARAMS = CC=$CC AR=$AR"
  '';

  postInstall = ''
    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = with lib; {
    description = "Decentralized peer to peer chat application";
    homepage = "https://retroshare.cc/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
