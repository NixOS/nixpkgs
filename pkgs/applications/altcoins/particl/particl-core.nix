{ stdenv
, autoreconfHook
, boost
, db48
, fetchurl
, libevent
, miniupnpc
, openssl
, pkgconfig
, zeromq
, zlib
, unixtools
, qtbase ? null
, qttools ? null
, qrencode ? null
, protobuf ? null
, hidapi ? null
, withGui
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "particl-${if withGui then "qt" else "core"}-${version}";
  version     = "0.16.2.0";

  src = fetchurl {
    url = "https://github.com/particl/particl-core/archive/v${version}.tar.gz";
    sha256 = "1d2vvg7avlhsg0rcpd5pbzafnk1w51a2y29xjjkpafi6iqs2l617";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    openssl db48 boost zlib miniupnpc libevent zeromq unixtools.hexdump ]
    ++ optionals withGui [ qtbase qttools qrencode protobuf hidapi ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
    ++ optionals withGui [
    "--with-gui=qt5"
    "--enable-usbdevice=yes"
    "--with-qt-bindir=${qtbase}/bin:${qttools}/bin:${qtbase.dev}/bin:${qttools.dev}/bin" ];

  meta = {
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription= ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
    '';
    homepage = https://particl.io/;
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
