{ stdenv, fetchurl, pkgconfig, qttools, scons
, GConf, avahi, boost, hunspell, libXScrnSaver, libedit, libidn, libnatpmp, libxml2
, lua, miniupnpc, openssl, qtbase, qtmultimedia, qtsvg, qtwebkit, qtx11extras, zlib
}:

let
  _scons = "scons -j$NIX_BUILD_CORES";
in stdenv.mkDerivation rec {
  name = "swift-im-${version}";
  version = "4.0.2";

  src = fetchurl {
    url = "https://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "0w0aiszjd58ynxpacwcgf052zpmbpcym4dhci64vbfgch6wryz0w";
  };

  patches = [ ./qt-5.11.patch ./scons.patch ];

  nativeBuildInputs = [ pkgconfig qttools scons ];

  buildInputs = [
    GConf avahi boost hunspell libXScrnSaver libedit libidn libnatpmp libxml2
    lua miniupnpc openssl qtbase qtmultimedia qtsvg qtwebkit qtx11extras zlib
  ];

  propagatedUserEnvPkgs = [ GConf ];

  NIX_CFLAGS_COMPILE = [
    "-I${libxml2.dev}/include/libxml2"
    "-I${miniupnpc}/include/miniupnpc"
    "-I${qtwebkit.dev}/include/QtWebKit"
    "-I${qtwebkit.dev}/include/QtWebKitWidgets"
  ];

  buildPhase = ''
    ${_scons} Swift
  '';

  installPhase = ''
    ${_scons} SWIFT_INSTALLDIR=$out $out
  '';

  meta = with stdenv.lib; {
    homepage = https://swift.im/;
    description = "Qt XMPP client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
