{ stdenv
, fetchgit
, autoreconfHook
, help2man
, pkgconfig
, libsndfile
, fftwFloat
, libjack2
, libxml2
, qt4
, boost
, ecasound
, glibcLocales
, mesa # Needed because help2man basically does a ./ssr-binaural  --help and ssr-binaural needs libGL
}:

stdenv.mkDerivation rec {
  name = "soundscape-renderer-unstable-${version}";

  version = "2016-11-03";

  src = fetchgit {
    url = https://github.com/SoundScapeRenderer/ssr;
    rev = "0dd0136dd24e47b63d8a4e05de467f5c7b047ec9";
    sha256 = "095x2spv9bmg6pi71mpajnghbqj58ziflg16f9854awx0qp9d8x7";
  };

  # Without it doesn't find all of the boost libraries.
  BOOST_LIB_DIR="${boost}/lib";

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ autoreconfHook boost boost.dev ecasound mesa help2man pkgconfig libsndfile fftwFloat libjack2 libxml2 qt4 glibcLocales ];

  # 1) Fix detecting version. https://github.com/SoundScapeRenderer/ssr/pull/53
  # 2) Make it find ecasound headers
  # 3) Fix locale for help2man
  prePatch = ''
    substituteInPlace configure.ac --replace 'git describe ||' 'git describe 2> /dev/null ||';
    substituteInPlace configure.ac --replace '/{usr,opt}/{,local/}' '${ecasound}/'
    substituteInPlace man/Makefile.am --replace '--locale=en' '--locale=en_US.UTF-8'
  '';

  meta = {
    homepage = http://spatialaudio.net/ssr/;
    description = "The SoundScape Renderer (SSR) is a tool for real-time spatial audio reproduction";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fridh ];
  };

}
