{ stdenv, fetchFromGitHub, fetchpatch, boost, cmake, chromaprint, gettext, gst_all_1, liblastfm
, taglib, fftw, glew, qjson, sqlite, libgpod, libplist, usbmuxd, libmtp
, libpulseaudio, gvfs, libcdio, libechonest, libspotify, pcre, projectm, protobuf
, qca2, pkgconfig, sparsehash, config, makeWrapper, gst_plugins }:

let
  withIpod = config.clementine.ipod or false;
  withMTP = config.clementine.mtp or true;
  withCD = config.clementine.cd or true;
  withCloud = config.clementine.cloud or true;

  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    rev = version;
    sha256 = "0i3jkfs8dbfkh47jq3cnx7pip47naqg7w66vmfszk4d8vj37j62j";
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
    (fetchpatch {
      # Fixes compilation with chromaprint >= 1.4
      url = "https://github.com/clementine-player/Clementine/commit/d3ea0c8482dfd3f6264a30cfceb456076d76e6cd.patch";
      sha256 = "1ifrs5aqdzw16jbnf0z1ilir20chdnr9k5n21r99miq9hzjpbh12";
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
    pname = "clementine-free";
    inherit version;
    inherit src patches nativeBuildInputs postPatch;

    # gst_plugins needed for setup-hooks
    buildInputs = buildInputs ++ [ makeWrapper ] ++ gst_plugins;

    cmakeFlags = [ "-DUSE_SYSTEM_PROJECTM=ON" ];

    enableParallelBuilding = true;

    passthru.unfree = unfree;

    postInstall = ''
      wrapProgram $out/bin/clementine \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

    meta = with stdenv.lib; {
      homepage = http://www.clementine-player.org;
      description = "A multiplatform music player";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = [ maintainers.ttuegel ];
    };
  };

  # Unfree Spotify blob for Clementine
  unfree = stdenv.mkDerivation {
    pname = "clementine-blob";
    inherit version;
    # Use the same patches and sources as Clementine
    inherit src nativeBuildInputs postPatch;

    patches = [
      ./clementine-spotify-blob.patch
    ];

    buildInputs = buildInputs ++ [ libspotify makeWrapper ];
    # Only build and install the Spotify blob
    preBuild = ''
      cd ext/clementine-spotifyblob
    '';
    postInstall = ''
      mkdir -p $out/libexec/clementine
      mv $out/bin/clementine-spotifyblob $out/libexec/clementine
      rmdir $out/bin

      makeWrapper ${free}/bin/clementine $out/bin/clementine \
        --set CLEMENTINE_SPOTIFYBLOB $out/libexec/clementine

      mkdir -p $out/share
      for dir in applications icons kde4; do
        ln -s "${free}/share/$dir" "$out/share/$dir"
      done
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

in free
