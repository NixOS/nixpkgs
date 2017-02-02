{ stdenv, fetchFromGitHub, cmake, ecm, gettext, pkgconfig, runCommand
, liblastfm, taglib, fftw, glew, sqlite, libgpod, libplist
, usbmuxd, libmtp, gvfs, libcdio, libspotify, protobuf, pcre
, sparsehash, config, boost, gst_all_1
, chromaprint, cryptopp, libechonest, libpulseaudio
, withQt4 ? true, qt4 ? null, qjson ? null, qca2 ? null, makeWrapper
, withQt5 ? false, qtbase ? null, qttools ? null, qtwebkit ? null, qtx11extras ? null
}:

let
  withSpotify = config.clementine.spotify or false;
  withIpod    = config.clementine.ipod    or false;
  withMTP     = config.clementine.mtp     or true;
  withCD      = config.clementine.cd      or true;
  withCloud   = config.clementine.cloud   or true;

  baseVersion = "1.3.1";
  patchDate   = "20170708";

  rev =     if withQt4 then baseVersion else "fbc2f78f8899ae174b094494ff42fb06d2157b1b";
  version = if withQt4 then baseVersion else "${baseVersion}-${patchDate}";
  sha256  = if withQt4 then
    "0i3jkfs8dbfkh47jq3cnx7pip47naqg7w66vmfszk4d8vj37j62j"
  else
    "0hnnvvcd1af1qyhzfph12m7v2ncqsdj3fx1r12d04r3v5fxzihjf";

  src = fetchFromGitHub {
    owner  = "clementine-player";
    repo   = "Clementine";
    inherit rev sha256;
  };

  patches = [
    ./clementine-spotify-blob.patch
  ];

  prePatch = ''
    for f in src/main.cpp ext/clementine-spotifyblob/main.cpp ; do
      substituteInPlace $f \
        --replace "Clementine-qt5" "Clementine"
    done
  '';

  gst_plugins = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-libav
    gst-plugins-ugly
    # gst-plugins-bad
  ];

  buildInputs = [
    boost
    fftw
    gettext
    glew
    gst_all_1.gstreamer
    gvfs
    libechonest
    liblastfm
    pcre
    protobuf
    sqlite
    taglib

    chromaprint
    cryptopp
    libpulseaudio
  ] ++ gst_plugins # gst_plugins is a list
    ++ stdenv.lib.optionals withQt4 [
      makeWrapper
      qt4
      qca2
      qjson
  ] ++ stdenv.lib.optionals withQt5 [
      qtbase
      qttools
      qtwebkit
      qtx11extras
  ] ++ stdenv.lib.optionals (withIpod)  [ libgpod libplist usbmuxd ]
    ++ stdenv.lib.optionals (withMTP)   [ libmtp ]
    ++ stdenv.lib.optionals (withCD)    [ libcdio ]
    ++ stdenv.lib.optionals (withCloud) [ sparsehash ];

  nativeBuildInputs = [ cmake ecm pkgconfig ];

  enableParallelBuilding = true;

  free = stdenv.mkDerivation {
    name = "clementine-free-${version}";
    inherit patches src buildInputs nativeBuildInputs enableParallelBuilding;
    cmakeFlags = [
      "-DCRYPTOPP_FOUND=1"
      "-DCRYPTOPP_INCLUDE_DIRS=${cryptopp}/include"
      "-DCRYPTOPP_LIBRARIES=${cryptopp}/lib/libcryptopp.so"
      "-Wno-dev"
    ];
    postPatch = ''
      substituteInPlace src/CMakeLists.txt \
        --replace '-Werror' "" \
        --replace '-Wno-unknown-warning-option' "" \
        --replace '-Wno-unused-private-field' ""

      rm -rf 3rdparty/{taglib}
    '';
    meta = with stdenv.lib; {
      homepage = http://www.clementine-player.org;
      description = "A multiplatform music player";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ttuegel ];
    };
  };

  # Spotify blob for Clementine
  blob = stdenv.mkDerivation {
    name = "clementine-blob-${version}";
    inherit patches src nativeBuildInputs enableParallelBuilding;
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
    meta = with stdenv.lib; {
      description = "Spotify integration for Clementine";
      # The blob itself is Apache-licensed, although libspotify is unfree.
      license = licenses.asl20;
      inherit (free.meta) homepage platforms maintainers;
    };
  };

in

with stdenv.lib;

runCommand "clementine-${version}" {
  inherit blob free;
  buildInputs = [
    ecm makeWrapper
  ] ++ gst_plugins; # for the setup-hooks
  dontPatchELF = true;
  dontStrip = true;
  meta = {
    description = "A multiplatform music player"
      + " (" + (optionalString withSpotify "with Spotify, ")
      + "with gstreamer plugins: "
      + concatStrings (intersperse ", " (map (x: x.name) gst_plugins))
      + ")";
    inherit (free.meta) homepage license platforms maintainers;
  };
}
''
  mkdir -p $out/{bin,share}

  makeWrapper $free/bin/clementine $out/bin/clementine \
    ${optionalString withSpotify "--set CLEMENTINE_SPOTIFYBLOB \"$blob/libexec/clementine\""}

  for dir in applications icons kde4 kservices5; do
    if [ -e $free/share/$dir ] ; then
      ln -s "$free/share/$dir" "$out/share/$dir"
    fi
  done
''
