{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig, vlc
, qtbase, qtmultimedia, qtsvg, qttools

# Cantata doesn't build with cdparanoia enabled so we disable that
# default for now until I (or someone else) figure it out.
, withCdda ? false, cdparanoia
, withCddb ? false, libcddb
, withLame ? false, lame
, withMusicbrainz ? false, libmusicbrainz5

, withTaglib ? true, taglib, taglib_extras
, withReplaygain ? true, ffmpeg, speex, mpg123
, withMtp ? true, libmtp
, withOnlineServices ? true
, withDevices ? true, udisks2
, withDynamic ? true
, withHttpServer ? true
, withStreams ? true
}:

# Inter-dependencies.
assert withCddb -> withCdda && withTaglib;
assert withCdda -> withCddb && withMusicbrainz;
assert withLame -> withCdda && withTaglib;
assert withMtp -> withTaglib;
assert withMusicbrainz -> withCdda && withTaglib;
assert withOnlineServices -> withTaglib;
assert withReplaygain -> withTaglib;

let
  version = "2.2.0";
  pname = "cantata";
  fstat = x: fn: "-DENABLE_" + fn + "=" + (if x then "ON" else "OFF");
  fstats = x: map (fstat x);

  withUdisks = (withTaglib && withDevices);

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "CDrummond";
    repo   = "cantata";
    rev    = "v${version}";
    sha256 = "1b633chgfs8rya78bzzck5zijna15d1y4nmrz4dcjp862ks5y5q6";
  };

  patches = [
    # patch is needed for 2.2.0 with qt 5.10 (doesn't harm earlier versions)
    (fetchpatch {
      url    = "https://github.com/CDrummond/cantata/commit/4da7a9128f2c5eaf23ae2a5006d300dc4f21fc6a.patch";
      sha256 = "1z21ax3542z7hm628xv110lmplaspb407jzgfk16xkphww5qyphj";
      name   = "fix_qt_510.patch";
    })

  ];
  buildInputs = [ vlc qtbase qtmultimedia qtsvg ]
    ++ stdenv.lib.optionals withTaglib [ taglib taglib_extras ]
    ++ stdenv.lib.optionals withReplaygain [ ffmpeg speex mpg123 ]
    ++ stdenv.lib.optional  withCdda cdparanoia
    ++ stdenv.lib.optional  withCddb libcddb
    ++ stdenv.lib.optional  withLame lame
    ++ stdenv.lib.optional  withMtp libmtp
    ++ stdenv.lib.optional  withMusicbrainz libmusicbrainz5
    ++ stdenv.lib.optional  withUdisks udisks2;

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.flatten [
    (fstats withTaglib        [ "TAGLIB" "TAGLIB_EXTRAS" ])
    (fstats withReplaygain    [ "FFMPEG" "MPG123" "SPEEXDSP" ])
    (fstat withCdda           "CDPARANOIA")
    (fstat withCddb           "CDDB")
    (fstat withLame           "LAME")
    (fstat withMtp            "MTP")
    (fstat withMusicbrainz    "MUSICBRAINZ")
    (fstat withOnlineServices "ONLINE_SERVICES")
    (fstat withDynamic        "DYNAMIC")
    (fstat withDevices        "DEVICES_SUPPORT")
    (fstat withHttpServer     "HTTP_SERVER")
    (fstat withStreams        "STREAMS")
    (fstat withUdisks         "UDISKS2")
    "-DENABLE_HTTPS_SUPPORT=ON"
  ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/cdrummond/cantata;
    description = "A graphical client for MPD";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ fuuzetsu peterhoeg ];
    # Technically Cantata can run on Windows so if someone wants to
    # bother figuring that one out, be my guest.
    platforms   = platforms.linux;
  };
}
