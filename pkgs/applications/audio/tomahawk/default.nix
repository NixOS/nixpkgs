{ stdenv, fetchurl, cmake, pkgconfig, attica, boost, gnutls, libechonest
, liblastfm, lucenepp, phonon, qca2, qjson, qt4, qtkeychain, quazip, sparsehash
, taglib, websocketpp

, enableXMPP      ? true,  libjreen     ? null
, enableKDE       ? false, kdelibs      ? null
, enableTelepathy ? false, telepathy_qt ? null
}:

assert enableXMPP      -> libjreen     != null;
assert enableKDE       -> kdelibs      != null;
assert enableTelepathy -> telepathy_qt != null;

let
  quazipQt4 = quazip.override { qt = qt4; };
in stdenv.mkDerivation rec {
  name = "tomahawk-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "http://download.tomahawk-player.org/tomahawk-0.8.1.tar.bz2";
    sha256 = "0ca6fah30a2s8nnlryav95wyzhwys1ikjfwakrqf2hb0y5aczdpw";
  };

  cmakeFlags = [
    "-DLUCENEPP_INCLUDE_DIR=${lucenepp}/include"
    "-DLUCENEPP_LIBRARY_DIR=${lucenepp}/lib"
  ];

  buildInputs = [
    cmake pkgconfig attica boost gnutls libechonest liblastfm lucenepp phonon
    qca2 qjson qt4 qtkeychain quazipQt4 sparsehash taglib websocketpp
  ] ++ stdenv.lib.optional enableXMPP      libjreen
    ++ stdenv.lib.optional enableKDE       kdelibs
    ++ stdenv.lib.optional enableTelepathy telepathy_qt;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A multi-source music player";
    homepage = "http://tomahawk-player.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.aszlig ];
  };
}
