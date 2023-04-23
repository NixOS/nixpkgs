{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, help2man
, pkg-config
, libsndfile
, fftwFloat
, libjack2
, libxml2
, qt4
, boost
, ecasound
, glibcLocales
, libGLU
, libGL # Needed because help2man basically does a ./ssr-binaural  --help and ssr-binaural needs libGL
}:

stdenv.mkDerivation {
  pname = "soundscape-renderer";
  version = "unstable-2016-11-03";

  src = fetchFromGitHub {
    owner = "SoundScapeRenderer";
    repo = "ssr";
    rev = "0dd0136dd24e47b63d8a4e05de467f5c7b047ec9";
    sha256 = "sha256-9s+Elaxz9kX+Nle1CqBU/9r0hdI4dhsJ6GrNqvP5HIs=";
  };

  # Without it doesn't find all of the boost libraries.
  BOOST_LIB_DIR = "${boost}/lib";
  # uses the deprecated get_generic_category() in boost_system
  env.NIX_CFLAGS_COMPILE = "-DBOOST_SYSTEM_ENABLE_DEPRECATED=1";

  LC_ALL = "en_US.UTF-8";

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ boost boost.dev ecasound libGLU libGL help2man libsndfile fftwFloat libjack2 libxml2 qt4 glibcLocales ];

  # 1) Fix detecting version. https://github.com/SoundScapeRenderer/ssr/pull/53
  # 2) Make it find ecasound headers
  # 3) Fix locale for help2man
  prePatch = ''
    substituteInPlace configure.ac --replace 'git describe ||' 'git describe 2> /dev/null ||';
    substituteInPlace configure.ac --replace '/{usr,opt}/{,local/}' '${ecasound}/'
    substituteInPlace man/Makefile.am --replace '--locale=en' '--locale=en_US.UTF-8'
  '';

  meta = {
    homepage = "http://spatialaudio.net/ssr/";
    description = "The SoundScape Renderer (SSR) is a tool for real-time spatial audio reproduction";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.fridh ];
  };

}
