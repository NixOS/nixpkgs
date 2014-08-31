{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, protobuf, libspotify, qca2, pkgconfig
, sparsehash, config }:

let withSpotify = config.clementine.spotify or false;
in
stdenv.mkDerivation {
  name = "clementine-1.2.3";

  src = fetchurl {
    url = https://github.com/clementine-player/Clementine/archive/1.2.3.tar.gz;
    sha256 = "1gx1109i4pylz6x7gvp4rdzc6dvh0w6in6hfbygw01d08l26bxbx";
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
    pkgconfig
    protobuf
    qca2
    qjson
    qt4
    sparsehash
    sqlite
    taglib
    usbmuxd
  ] ++ stdenv.lib.optional withSpotify libspotify;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.clementine-player.org";
    description = "A multiplatform music player";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
    # libspotify is unfree
    hydraPlatforms = optionals (!withSpotify) platforms.linux;
  };
}
