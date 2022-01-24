{ lib
, stdenv
, fetchurl
, boost
, libmpdclient
, ncurses
, pkg-config
, readline
, libiconv
, icu
, curl
, outputsSupport ? true # outputs screen
, visualizerSupport ? false, fftw ? null # visualizer screen
, clockSupport ? true # clock screen
, taglibSupport ? true, taglib ? null # tag editor
}:

assert visualizerSupport -> (fftw != null);
assert taglibSupport -> (taglib != null);

with lib;
stdenv.mkDerivation rec {
  pname = "ncmpcpp";
  version = "0.9.2";

  src = fetchurl {
    url = "https://rybczak.net/ncmpcpp/stable/${pname}-${version}.tar.bz2";
    sha256 = "sha256-+qv2FXyMsbJKBZryduFi+p+aO5zTgQxDuRKIYMk4Ohs=";
  };

  enableParallelBuilding = true;
  configureFlags = [ "BOOST_LIB_SUFFIX=" ]
    ++ optional outputsSupport "--enable-outputs"
    ++ optional visualizerSupport "--enable-visualizer --with-fftw"
    ++ optional clockSupport "--enable-clock"
    ++ optional taglibSupport "--with-taglib";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ boost libmpdclient ncurses readline libiconv icu curl ]
    ++ optional visualizerSupport fftw
    ++ optional taglibSupport taglib;

  meta = {
    description = "A featureful ncurses based MPD client inspired by ncmpc";
    homepage    = "https://rybczak.net/ncmpcpp/";
    changelog   = "https://github.com/ncmpcpp/ncmpcpp/blob/${version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ jfrankenau koral lovek323 ];
    platforms   = platforms.all;
  };
}
