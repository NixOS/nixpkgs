{ mkDerivation
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qtsvg
, qttools
, perl

  # Cantata doesn't build with cdparanoia enabled so we disable that
  # default for now until I (or someone else) figure it out.
, withCdda ? false
, cdparanoia
, withCddb ? false
, libcddb
, withLame ? false
, lame
, withMusicbrainz ? false
, libmusicbrainz5

, withTaglib ? true
, taglib
, taglib_extras
, withHttpStream ? true
, qtmultimedia
, withReplaygain ? true
, ffmpeg
, speex
, mpg123
, withMtp ? true
, libmtp
, withOnlineServices ? true
, withDevices ? true
, udisks2
, withDynamic ? true
, withHttpServer ? true
, withLibVlc ? false
, libvlc
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
  fstat = x: fn:
    "-DENABLE_${fn}=${if x then "ON" else "OFF"}";

  fstats = x:
    map (fstat x);

  withUdisks = (withTaglib && withDevices);

  perl' = perl.withPackages (ppkgs: with ppkgs; [ URI ]);

in
mkDerivation rec {
  pname = "cantata";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "CDrummond";
    repo = "cantata";
    rev = "v${version}";
    sha256 = "15qfx9bpfdplxxs08inwf2j8kvf7g5cln5sv1wj1l2l41vbf1mjr";
  };

  patches = [
    # Cantata wants to check if perl is in the PATH at runtime, but we
    # patchShebangs the playlists scripts, making that unnecessary (perl will
    # always be available because it's a dependency)
    ./dont-check-for-perl-in-PATH.diff
  ];

  postPatch = ''
    patchShebangs playlists
  '';

  buildInputs = [ qtbase qtsvg perl' ]
    ++ lib.optionals withTaglib [ taglib taglib_extras ]
    ++ lib.optionals withReplaygain [ ffmpeg speex mpg123 ]
    ++ lib.optional withHttpStream qtmultimedia
    ++ lib.optional withCdda cdparanoia
    ++ lib.optional withCddb libcddb
    ++ lib.optional withLame lame
    ++ lib.optional withMtp libmtp
    ++ lib.optional withMusicbrainz libmusicbrainz5
    ++ lib.optional withUdisks udisks2
    ++ lib.optional withLibVlc libvlc;

  nativeBuildInputs = [ cmake pkg-config qttools ];

  cmakeFlags = lib.flatten [
    (fstats withTaglib [ "TAGLIB" "TAGLIB_EXTRAS" ])
    (fstats withReplaygain [ "FFMPEG" "MPG123" "SPEEXDSP" ])
    (fstat withHttpStream "HTTP_STREAM_PLAYBACK")
    (fstat withCdda "CDPARANOIA")
    (fstat withCddb "CDDB")
    (fstat withLame "LAME")
    (fstat withMtp "MTP")
    (fstat withMusicbrainz "MUSICBRAINZ")
    (fstat withOnlineServices "ONLINE_SERVICES")
    (fstat withDynamic "DYNAMIC")
    (fstat withDevices "DEVICES_SUPPORT")
    (fstat withHttpServer "HTTP_SERVER")
    (fstat withLibVlc "LIBVLC")
    (fstat withStreams "STREAMS")
    (fstat withUdisks "UDISKS2")
    "-DENABLE_HTTPS_SUPPORT=ON"
  ];

  meta = with lib; {
    description = "A graphical client for MPD";
    homepage = "https://github.com/cdrummond/cantata";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    # Technically, Cantata should run on Darwin/Windows so if someone wants to
    # bother figuring that one out, be my guest.
    platforms = platforms.linux;
  };
}
