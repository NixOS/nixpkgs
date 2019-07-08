{ stdenv, fetchurl, boost, mpd_clientlib, ncurses, pkgconfig, readline
, libiconv, icu, curl
, outputsSupport ? true # outputs screen
, visualizerSupport ? false, fftw ? null # visualizer screen
, clockSupport ? true # clock screen
, taglibSupport ? true, taglib ? null # tag editor
}:

assert visualizerSupport -> (fftw != null);
assert taglibSupport -> (taglib != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "ncmpcpp-${version}";
  version = "0.8.2";

  src = fetchurl {
    url = "https://ncmpcpp.rybczak.net/stable/${name}.tar.bz2";
    sha256 = "0m0mjb049sl62vx13h9waavysa30mk0rphacksnvf94n13la62v5";
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
    maintainers = with maintainers; [ jfrankenau koral lovek323 ];
    platforms   = platforms.all;
  };
}
