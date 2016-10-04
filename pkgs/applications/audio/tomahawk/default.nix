{ stdenv, fetchurl, cmake, pkgconfig, attica, boost, gnutls, libechonest
, liblastfm, lucenepp, phonon, phonon-backend-vlc, qca2, qjson, qt4
, qtkeychain, quazip, sparsehash, taglib, websocketpp, makeWrapper

, enableXMPP      ? true,  libjreen     ? null
, enableKDE       ? false, kdelibs      ? null
, enableTelepathy ? false, telepathy_qt ? null
}:

assert enableXMPP      -> libjreen     != null;
assert enableKDE       -> kdelibs      != null;
assert enableTelepathy -> telepathy_qt != null;

stdenv.mkDerivation rec {
  name = "tomahawk-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "http://download.tomahawk-player.org/${name}.tar.bz2";
    sha256 = "0j84h36wkjfjbsd7ybyji7rcc9wpjdbl0f1xdcc1g7h0nz34pc0g";
  };

  cmakeFlags = [
    "-DLUCENEPP_INCLUDE_DIR=${lucenepp}/include"
    "-DLUCENEPP_LIBRARY_DIR=${lucenepp}/lib"
  ];

  buildInputs = [
    cmake pkgconfig attica boost gnutls libechonest liblastfm lucenepp phonon
    qca2 qjson qt4 qtkeychain quazip sparsehash taglib websocketpp
    makeWrapper
  ] ++ stdenv.lib.optional enableXMPP      libjreen
    ++ stdenv.lib.optional enableKDE       kdelibs
    ++ stdenv.lib.optional enableTelepathy telepathy_qt;

  postInstall = let
    pluginPath = stdenv.lib.concatStringsSep ":" [
      "${phonon-backend-vlc}/lib/kde4/plugins"
    ];
  in ''
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix QT_PLUGIN_PATH : "${pluginPath}"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A multi-source music player";
    homepage = "http://tomahawk-player.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.aszlig ];
  };
}
