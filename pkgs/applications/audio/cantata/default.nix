{ stdenv, fetchFromGitHub, cmake, pkgconfig, vlc
, withQt4 ? false, qt4
, withQt5 ? true, qtbase, qtmultimedia, qtsvg, qttools

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

# One and only one front-end.
assert withQt5 -> withQt4 == false;
assert withQt4 -> withQt5 == false;
assert withQt4 || withQt5;

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
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "CDrummond";
    repo   = "cantata";
    rev    = "v${version}";
    sha256 = "1b633chgfs8rya78bzzck5zijna15d1y4nmrz4dcjp862ks5y5q6";
  };

  buildInputs = [ vlc ]
    ++ stdenv.lib.optional  withQt4 qt4
    ++ stdenv.lib.optionals withQt5 [ qtbase qtmultimedia qtsvg qttools ]
    ++ stdenv.lib.optionals withTaglib [ taglib taglib_extras ]
    ++ stdenv.lib.optionals withReplaygain [ ffmpeg speex mpg123 ]
    ++ stdenv.lib.optional  withCdda cdparanoia
    ++ stdenv.lib.optional  withCddb libcddb
    ++ stdenv.lib.optional  withLame lame
    ++ stdenv.lib.optional  withMtp libmtp
    ++ stdenv.lib.optional  withMusicbrainz libmusicbrainz5
    ++ stdenv.lib.optional  (withTaglib && withDevices) udisks2;

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.flatten [
    (fstat withQt5 "QT5")
    (fstats withTaglib [ "TAGLIB" "TAGLIB_EXTRAS" ])
    (fstats withReplaygain [ "FFMPEG" "MPG123" "SPEEXDSP" ])
    (fstat withCdda "CDPARANOIA")
    (fstat withCddb "CDDB")
    (fstat withLame "LAME")
    (fstat withMtp "MTP")
    (fstat withMusicbrainz "MUSICBRAINZ")
    (fstat withOnlineServices "ONLINE_SERVICES")
    (fstat withDynamic "DYNAMIC")
    (fstat withDevices "DEVICES_SUPPORT")
    (fstat withHttpServer "HTTP_SERVER")
    (fstat withStreams "STREAMS")
    "-DENABLE_HTTPS_SUPPORT=ON"
    "-DENABLE_UDISKS2=ON"
  ];

  # This is already fixed upstream but not released yet. Maybe in version 2.
  preConfigure = ''
    # sed -i -e 's/STRLESS/VERSION_LESS/g' cmake/FindTaglib.cmake
  '';

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
