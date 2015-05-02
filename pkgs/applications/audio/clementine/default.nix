{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, protobuf, libspotify, qca2, pkgconfig
, sparsehash, config, makeWrapper, runCommand, gst_plugins }:

let
  version = "1.2.3";

  exeName = "clementine";

  unwrapped = stdenv.mkDerivation {
    name = "clementine-unwrapped-${version}";

    src = fetchurl {
      url = https://github.com/clementine-player/Clementine/archive/1.2.3.tar.gz;
      sha256 = "1gx1109i4pylz6x7gvp4rdzc6dvh0w6in6hfbygw01d08l26bxbx";
    };

    patches = [
      ./clementine-1.2.1-include-paths.patch
      ./clementine-dbus-namespace.patch
    ];

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
    ];

    enableParallelBuilding = true;
  };

in

runCommand "clementine-${version}"
{
  buildInputs = [ unwrapped makeWrapper ] ++ gst_plugins;
  dontPatchELF = true;
  dontStrip = true;
  meta = with stdenv.lib; {
    homepage = "http://www.clementine-player.org";
    description = "A multiplatform music player"
      + " (with gstreamer plugins: "
      + concatStrings (intersperse ", " (map (x: x.name) gst_plugins))
      + ")";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };
}
''
  mkdir -p $out/bin
  makeWrapper "${unwrapped}/bin/${exeName}" "$out/bin/${exeName}" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
''
