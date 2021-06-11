{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, boost
, cmake
, chromaprint
, gettext
, gst_all_1
, liblastfm
, qtbase
, qtx11extras
, qttools
, taglib
, fftw
, glew
, qjson
, sqlite
, libgpod
, libplist
, usbmuxd
, libmtp
, libpulseaudio
, gvfs
, libcdio
, libechonest
, libspotify
, pcre
, projectm
, protobuf
, qca2
, pkg-config
, sparsehash
, config
, makeWrapper
, gst_plugins

, util-linux
, libunwind
, libselinux
, elfutils
, libsepol
, orc

, alsa-lib
}:

let
  withIpod = config.clementine.ipod or false;
  withMTP = config.clementine.mtp or true;
  withCD = config.clementine.cd or true;
  withCloud = config.clementine.cloud or true;

  # On the update after all 1.4rc, qt5.15 and protobuf 3.15 will be supported.
  version = "1.4.0rc1";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    rev = version;
    sha256 = "1rqk0hrsn8f8bjk0j0vq1af0ygy6xx7qi9fw0jjw2cmj6kzckyi2";
  };

  patches = [
    ./clementine-spotify-blob.patch
    (fetchpatch {
      # "short-term" fix for execution on wayland (1.4.0rc1-131-g2179027a6)
      # for https://github.com/clementine-player/Clementine/issues/6587
      url = "https://github.com/clementine-player/Clementine/commit/2179027a6d97530c857e43be873baacd696ff332.patch";
      sha256 = "0344bfcyvjim5ph8w4km6zkg96rj5g9ybp9x14qgyw2gkdksimn6";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper

    util-linux
    libunwind
    libselinux
    elfutils
    libsepol
    orc
  ];

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
    qtbase
    qtx11extras
    qttools
    sqlite
    taglib

    alsa-lib
  ]
  ++ lib.optionals (withIpod) [ libgpod libplist usbmuxd ]
  ++ lib.optionals (withMTP) [ libmtp ]
  ++ lib.optionals (withCD) [ libcdio ]
  ++ lib.optionals (withCloud) [ sparsehash ];

  postPatch = ''
    sed -i src/CMakeLists.txt \
      -e 's,-Werror,,g' \
      -e 's,-Wno-unknown-warning-option,,g' \
      -e 's,-Wno-unused-private-field,,g'
    sed -i CMakeLists.txt \
      -e 's,libprotobuf.a,protobuf,g'
  '';

  free = mkDerivation {
    pname = "clementine-free";
    inherit version;
    inherit src patches nativeBuildInputs postPatch;

    # gst_plugins needed for setup-hooks
    buildInputs = buildInputs ++ gst_plugins;

    preConfigure = ''
      rm -rf ext/{,lib}clementine-spotifyblob
    '';

    cmakeFlags = [
      "-DUSE_SYSTEM_PROJECTM=ON"
      "-DSPOTIFY_BLOB=OFF"
    ];

    passthru.unfree = unfree;

    postInstall = ''
      wrapProgram $out/bin/clementine \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

    meta = with lib; {
      homepage = "https://www.clementine-player.org";
      description = "A multiplatform music player";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = [ maintainers.ttuegel ];
    };
  };

  # Unfree Spotify blob for Clementine
  unfree = mkDerivation {
    pname = "clementine-blob";
    inherit version;
    # Use the same patches and sources as Clementine
    inherit src nativeBuildInputs patches postPatch;

    buildInputs = buildInputs ++ [ libspotify ];
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

    meta = with lib; {
      homepage = "https://www.clementine-player.org";
      description = "Spotify integration for Clementine";
      # The blob itself is Apache-licensed, although libspotify is unfree.
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.ttuegel ];
    };
  };

in
free
