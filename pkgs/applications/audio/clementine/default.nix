{ stdenv, fetchurl, fetchpatch, boost, cmake, chromaprint, gettext, gst_all_1, liblastfm
, qt4, taglib, fftw, glew, qjson, sqlite, libgpod, libplist, usbmuxd, libmtp
, libpulseaudio, gvfs, libcdio, libechonest, libspotify, pcre, projectm, protobuf
, qca2, pkgconfig, sparsehash, config, makeWrapper, runCommand, gst_plugins }:

let
  withSpotify = config.clementine.spotify or false;
  withIpod = config.clementine.ipod or false;
  withMTP = config.clementine.mtp or true;
  withCD = config.clementine.cd or true;
  withCloud = config.clementine.cloud or true;

  version = "1.3.1";

  exeName = "clementine";

  src = fetchurl {
    url = https://github.com/clementine-player/Clementine/archive/1.3.1.tar.gz;
    sha256 = "0z7k73wyz54c3020lb6x2dgw0vz4ri7wcl3vs03qdj5pk8d971gq";
  };

  patches = [
    ./clementine-spotify-blob.patch
    # Required so as to avoid adding libspotify as a build dependency (as it is 
    # unfree and thus would prevent us from having a free package).
    ./clementine-spotify-blob-remove-from-build.patch
    (fetchpatch {
      # Fix w/gcc7
      url = "https://github.com/clementine-player/Clementine/pull/5630.patch";
      sha256 = "0px7xp1m4nvrncx8sga1qlxppk562wrk2qqk19iiry84nxg20mk4";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost
    chromaprint
    fftw
    gettext
    glew
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gvfs
    libechonest
    liblastfm
    libpulseaudio
    pcre
    projectm
    protobuf
    qca2
    qjson
    qt4
    sqlite
    taglib
  ]
  ++ stdenv.lib.optionals (withIpod) [libgpod libplist usbmuxd]
  ++ stdenv.lib.optionals (withMTP) [libmtp]
  ++ stdenv.lib.optionals (withCD) [libcdio]
  ++ stdenv.lib.optionals (withCloud) [sparsehash];

  postPatch = ''
    sed -i src/CMakeLists.txt \
      -e 's,-Werror,,g' \
      -e 's,-Wno-unknown-warning-option,,g' \
      -e 's,-Wno-unused-private-field,,g'
    sed -i CMakeLists.txt \
      -e 's,libprotobuf.a,protobuf,g'
  '';

  free = stdenv.mkDerivation {
    name = "clementine-free-${version}";
    inherit src patches nativeBuildInputs buildInputs postPatch;

    cmakeFlags = [ "-DUSE_SYSTEM_PROJECTM=ON" ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = http://www.clementine-player.org;
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
    inherit src nativeBuildInputs postPatch;

    patches = [
      ./clementine-spotify-blob.patch
    ];

    buildInputs = buildInputs ++ [ libspotify ];
    # Only build and install the Spotify blob
    preBuild = ''
      cd ext/clementine-spotifyblob
    '';
    postInstall = ''
      mkdir -p $out/libexec/clementine
      mv $out/bin/clementine-spotifyblob $out/libexec/clementine
      rmdir $out/bin
    '';
    enableParallelBuilding = true;
    meta = with stdenv.lib; {
      homepage = http://www.clementine-player.org;
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
  buildInputs = [ makeWrapper ] ++ gst_plugins; # for the setup-hooks
  dontPatchELF = true;
  dontStrip = true;
  meta = {
    description = "A multiplatform music player"
      + " (" + (optionalString withSpotify "with Spotify, ")
      + "with gstreamer plugins: "
      + concatStrings (intersperse ", " (map (x: x.name) gst_plugins))
      + ")";
    license = licenses.gpl3Plus;
    inherit (free.meta) homepage platforms maintainers;
  };
}
''
  mkdir -p $out/bin
  makeWrapper "$free/bin/${exeName}" "$out/bin/${exeName}" \
      ${optionalString withSpotify "--set CLEMENTINE_SPOTIFYBLOB \"$blob/libexec/clementine\""} \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"

  mkdir -p $out/share
  for dir in applications icons kde4; do
      ln -s "$free/share/$dir" "$out/share/$dir"
  done
''
