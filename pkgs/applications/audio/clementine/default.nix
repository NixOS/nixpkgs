{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, protobuf, libspotify, qca2, pkgconfig
, sparsehash, config, makeWrapper, gst_plugins }:

let 
  version = "1.2.3";

  withSpotify = config.clementine.spotify or false;

  wrappedExeName = "clementine";

  wrapped = stdenv.mkDerivation {
    name = "clementine-wrapped-${version}";

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
    ];

    enableParallelBuilding = true;
  };

in

stdenv.mkDerivation {
  name = "clementine-${version}";

  src = ./.;


  buildInputs = [
    wrapped
    makeWrapper
  ] ++ gst_plugins
    ++ stdenv.lib.optional withSpotify libspotify;

  installPhase = ''
    mkdir -p $out
    cp -a ${wrapped}/* $out
    chmod -R u+w-t $out

    wrapProgram "$out/bin/${wrappedExeName}" \
        --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  preferLocalBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = "http://www.clementine-player.org";
    description = "A multiplatform music player"
      + " ("
      + concatStrings (optionals (withSpotify) ["with spotify, "])
      + "with gstreamer plugins: "
      + concatStrings (intersperse ", " (map (x: x.name) gst_plugins))
      + ")";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
    # libspotify is unfree
    hydraPlatforms = optionals (!withSpotify) platforms.linux;
  };
}
