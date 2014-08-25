{ stdenv, fetchurl, cmake
, withQt4 ? true, qt4
, withQt5 ? false, qt5

# I'm unable to make KDE work here, crashes at runtime so I simply
# make Qt4 the default until someone who wants KDE can figure it out.
, withKDE4 ? false, kde4

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
assert withQt5 -> withQt4 == false && withKDE4 == false;
assert withQt4 -> withQt5 == false && withKDE4 == false;
assert withKDE4 -> withQt4 == false && withQt5 == false;
assert withQt4 || withQt5 || withKDE4;

# Inter-dependencies.
assert withCddb -> withCdda && withTaglib;
assert withCdda -> withCddb && withMusicbrainz;
assert withLame -> withCdda && withTaglib;
assert withMtp -> withTaglib;
assert withMusicbrainz -> withCdda && withTaglib;
assert withOnlineServices -> withTaglib;
assert withReplaygain -> withTaglib;

let
  version = "1.4.0";
  pname = "cantata";
  fstat = x: fn: "-DENABLE_" + fn + "=" + (if x then "ON" else "OFF");
  fstats = x: map (fstat x);
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    inherit name;
    url = "https://drive.google.com/uc?export=download&id=0Bzghs6gQWi60WDI1WjRtUDJ4QlU";
    sha256 = "63a03872ec9a2b212c497d4b10e255d5654f96370734e86420bf711354048e01";
  };

  buildInputs =
    [ cmake ]
    ++ stdenv.lib.optional withQt4 qt4
    ++ stdenv.lib.optional withQt5 qt5
    ++ stdenv.lib.optional withKDE4 kde4.kdelibs
    ++ stdenv.lib.optionals withTaglib [ taglib taglib_extras ]
    ++ stdenv.lib.optionals withReplaygain [ ffmpeg speex mpg123 ]
    ++ stdenv.lib.optional withCdda cdparanoia
    ++ stdenv.lib.optional withCddb libcddb
    ++ stdenv.lib.optional withLame lame
    ++ stdenv.lib.optional withMtp libmtp
    ++ stdenv.lib.optional withMusicbrainz libmusicbrainz5
    ++ stdenv.lib.optional (withTaglib && !withKDE4 && withDevices) udisks2;

  unpackPhase = "tar -xvf $src";
  sourceRoot = "cantata-1.4.0";

  # Qt4 is implicit when KDE is switched off.
  cmakeFlags = stdenv.lib.flatten [
    (fstats withKDE4 [ "KDE" "KWALLET" ])
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

  meta = with stdenv.lib; {
    homepage = "http://code.google.com/p/cantata/";
    description = "A graphical client for MPD.";
    license = licenses.gpl3;

    # Technically Cantata can run on Windows so if someone wants to
    # bother figuring that one out, be my guest.
    platforms = platforms.linux;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
