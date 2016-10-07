{ stdenv, fetchurl, boost, cmake, gettext, gstreamer, gst_plugins_base
, liblastfm, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, libspotify, protobuf, qca2, pkgconfig
, sparsehash, config, runCommand, gst_plugins, wrapGAppsHook }:

let
  withSpotify = config.clementine.spotify or false;

  version = "1.2.3";

  exeName = "clementine";

  src = fetchurl {
    url = https://github.com/clementine-player/Clementine/archive/1.2.3.tar.gz;
    sha256 = "1gx1109i4pylz6x7gvp4rdzc6dvh0w6in6hfbygw01d08l26bxbx";
  };

  patches = [
    ./clementine-1.2.1-include-paths.patch
    ./clementine-dbus-namespace.patch
    ./clementine-spotify-blob.patch
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

  free = stdenv.mkDerivation {
    name = "clementine-free-${version}";
    inherit patches src buildInputs;
    enableParallelBuilding = true;
    postPatch = ''
      sed -i src/CMakeLists.txt \
        -e 's,-Werror,,g' \
        -e 's,-Wno-unknown-warning-option,,g' \
        -e 's,-Wno-unused-private-field,,g'
    '';
    meta = with stdenv.lib; {
      homepage = "http://www.clementine-player.org";
      description = "A multiplatform music player";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = [ maintainers.ttuegel ];
    };
  };

  # Spotify blob for Clementine
  blob = stdenv.mkDerivation {
    name = "clementine-blob-${version}";
    # Use the same patches and sources as Clementine
    inherit patches src;
    buildInputs = buildInputs ++ [ libspotify ];
    # Only build and install the Spotify blob
    preBuild = ''
      cd ext/clementine-spotifyblob
    '';
    postInstall = ''
      mkdir -p $out/libexec/clementine
      mv $out/bin/clementine-spotifyblob $out/libexec/clementine/
      rmdir $out/bin
    '';
    enableParallelBuilding = true;
    meta = with stdenv.lib; {
      homepage = "http://www.clementine-player.org";
      description = "Spotify integration for Clementine";
      # The blob itself is Apache-licensed, although libspotify is unfree.
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.ttuegel ];
    };
  };

in

with stdenv.lib;

runCommand "clementine-${version}"
{
  inherit blob free;
  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = gst_plugins;
  dontPatchELF = true;
  dontStrip = true;
  meta = {
    homepage = "http://www.clementine-player.org";
    description = "A multiplatform music player"
      + " (" + (optionalString withSpotify "with Spotify, ")
      + "with gstreamer plugins: "
      + concatStrings (intersperse ", " (map (x: x.name) gst_plugins))
      + ")";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };
}
''
  mkdir -p $out/bin
  ln -s "$free/bin/${exeName}" "$out/bin/${exeName}"

  ${optionalString withSpotify ''
    gappsWrapperArgs+=(--set CLEMENTINE_SPOTIFYBLOB "$blob/libexec/clementine")
  ''}

  wrapGAppsHook

  mkdir -p $out/share
  for dir in applications icons kde4; do
      ln -s "$free/share/$dir" "$out/share/$dir"
  done
''
