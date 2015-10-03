{ stdenv, fetchurl, boost, mpd_clientlib, ncurses, pkgconfig, readline
, libiconv
, outputsSupport ? false # outputs screen
, visualizerSupport ? false, fftw ? null # visualizer screen
, clockSupport ? false # clock screen
, unicodeSupport ? true # utf8 support
, curlSupport ? true, curl ? null # allow fetching lyrics from the internet
, taglibSupport ? true, taglib ? null # tag editor
}:

assert visualizerSupport -> (fftw != null);
assert curlSupport -> (curl != null);
assert taglibSupport -> (taglib != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "ncmpcpp-${version}";
  version = "0.6.7";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/${name}.tar.bz2";
    sha256 = "0yr1ib14qkgbsv839anpzkfbwkm6gg8wv4bf98ar7q5l2p2pv008";
  };

  configureFlags = [ "BOOST_LIB_SUFFIX=" ]
    ++ optional outputsSupport "--enable-outputs"
    ++ optional visualizerSupport "--enable-visualizer --with-fftw"
    ++ optional clockSupport "--enable-clock"
    ++ optional unicodeSupport "--enable-unicode"
    ++ optional curlSupport "--with-curl"
    ++ optional taglibSupport "--with-taglib";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ boost mpd_clientlib ncurses readline libiconv ]
    ++ optional curlSupport curl
    ++ optional visualizerSupport fftw
    ++ optional taglibSupport taglib;

  meta = {
    description = "A featureful ncurses based MPD client inspired by ncmpc";
    homepage    = http://ncmpcpp.rybczak.net/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 mornfall koral ];
    platforms   = platforms.all;
  };
}
