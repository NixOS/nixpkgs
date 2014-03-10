{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, protobuf, libspotify, qca2, pkgconfig
, sparsehash }:

stdenv.mkDerivation {
  name = "clementine-1.2.1";

  src = fetchurl {
    url = http://clementine-player.googlecode.com/files/clementine-1.2.1.tar.gz;
    sha256 = "0kk5cjmb8nirx0im3c0z91af2k72zxi6lwzm6rb57qihya5nwmfv";
  };

  patches = [ ./clementine-1.2.1-include-paths.patch ];

  buildInputs = [
    boost
    cmake
    fftw
    gettext
    glew
    gst_plugins_base
    gstreamer
    gvfs
    libcdio
    libgpod
    liblastfm
    libmtp
    libplist
    libspotify
    pkgconfig
    protobuf
    qca2
    qjson
    qt4
    sparsehash
    sqlite
    taglib
    usbmuxd
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.clementine-player.org";
    description = "A multiplatform music player";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };
}
