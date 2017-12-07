{ stdenv, fetchurl, boost, mpd_clientlib, ncurses, pkgconfig, readline
, libiconv, icu, curl
, outputsSupport ? false # outputs screen
, visualizerSupport ? false, fftw ? null # visualizer screen
, clockSupport ? false # clock screen
, taglibSupport ? true, taglib ? null # tag editor
}:

assert visualizerSupport -> (fftw != null);
assert taglibSupport -> (taglib != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "ncmpcpp-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://ncmpcpp.rybczak.net/stable/${name}.tar.bz2";
    sha256 = "1zw8d07b2bkssbsybg6jnmpq001w525viajrnz4jvfml3l55gyad";
  };

  configureFlags = [ "BOOST_LIB_SUFFIX=" ]
    ++ optional outputsSupport "--enable-outputs"
    ++ optional visualizerSupport "--enable-visualizer --with-fftw"
    ++ optional clockSupport "--enable-clock"
    ++ optional taglibSupport "--with-taglib";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ boost mpd_clientlib ncurses readline libiconv icu curl ]
    ++ optional visualizerSupport fftw
    ++ optional taglibSupport taglib;

  meta = {
    description = "A featureful ncurses based MPD client inspired by ncmpc";
    homepage    = https://ncmpcpp.rybczak.net/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ jfrankenau koral lovek323 mornfall ];
    platforms   = platforms.all;
  };
}
