{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtsvg, qttools

# Cantata doesn't build with cdparanoia enabled so we disable that
# default for now until I (or someone else) figure it out.
, withCdda ? false, cdparanoia
, withCddb ? false, libcddb
, withLame ? false, lame
, withMusicbrainz ? false, libmusicbrainz5

, withTaglib ? true, taglib, taglib_extras
, withHttpStream ? true, qtmultimedia
, withReplaygain ? true, ffmpeg_3, speex, mpg123
, withMtp ? true, libmtp
, withOnlineServices ? true
, withDevices ? true, udisks2
, withDynamic ? true
, withHttpServer ? true
, withLibVlc ? false, vlc
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
assert withLibVlc -> withHttpStream;

let
  version = "2.4.1";
  pname = "cantata";
  fstat = x: fn: "-DENABLE_" + fn + "=" + (if x then "ON" else "OFF");
  fstats = x: map (fstat x);

  withUdisks = (withTaglib && withDevices);

in mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "CDrummond";
    repo   = "cantata";
    rev    = "v${version}";
    sha256 = "0ix7xp352bziwz31mw79y7wxxmdn6060p8ry2px243ni1lz1qx1c";
  };

  buildInputs = [ qtbase qtsvg ]
    ++ lib.optionals withTaglib [ taglib taglib_extras ]
    ++ lib.optionals withReplaygain [ ffmpeg_3 speex mpg123 ]
    ++ lib.optional  withHttpStream qtmultimedia
    ++ lib.optional  withCdda cdparanoia
    ++ lib.optional  withCddb libcddb
    ++ lib.optional  withLame lame
    ++ lib.optional  withMtp libmtp
    ++ lib.optional  withMusicbrainz libmusicbrainz5
    ++ lib.optional  withUdisks udisks2
    ++ lib.optional  withLibVlc vlc;

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  enableParallelBuilding = true;

  cmakeFlags = lib.flatten [
    (fstats withTaglib        [ "TAGLIB" "TAGLIB_EXTRAS" ])
    (fstats withReplaygain    [ "FFMPEG" "MPG123" "SPEEXDSP" ])
    (fstat withHttpStream     "HTTP_STREAM_PLAYBACK")
    (fstat withCdda           "CDPARANOIA")
    (fstat withCddb           "CDDB")
    (fstat withLame           "LAME")
    (fstat withMtp            "MTP")
    (fstat withMusicbrainz    "MUSICBRAINZ")
    (fstat withOnlineServices "ONLINE_SERVICES")
    (fstat withDynamic        "DYNAMIC")
    (fstat withDevices        "DEVICES_SUPPORT")
    (fstat withHttpServer     "HTTP_SERVER")
    (fstat withLibVlc         "LIBVLC")
    (fstat withStreams        "STREAMS")
    (fstat withUdisks         "UDISKS2")
    "-DENABLE_HTTPS_SUPPORT=ON"
  ];

  meta = with lib; {
    homepage    = "https://github.com/cdrummond/cantata";
    description = "A graphical client for MPD";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    # Technically Cantata can run on Windows so if someone wants to
    # bother figuring that one out, be my guest.
    platforms   = platforms.linux;
  };
}
