{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, protobuf, libspotify, qca2, pkgconfig
, sparsehash, config, makeWrapper, pulseaudio ? null
, gst_plugins_good, gst_plugins_bad ? null, gst_plugins_ugly ? null }:

assert (config.clementine.withGstPluginsBad or false) -> gst_plugins_bad != null;
assert (config.clementine.withGstPluginsUgly or false) -> gst_plugins_ugly != null;

let withSpotify = config.clementine.spotify or false;
    withGstPluginsBad = config.clementine.withGstPluginsBad or false;
    withGstPluginsUgly = config.clementine.withGstPluginsUgly or false;
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
    gst_plugins_good
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
    pulseaudio
    makeWrapper
  ] ++ stdenv.lib.optional withSpotify libspotify
    ++ stdenv.lib.optional withGstPluginsBad gst_plugins_bad
    ++ stdenv.lib.optional withGstPluginsUgly gst_plugins_ugly;

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/clementine \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

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
