{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblrdf, liblo, libsigcxx, wafHook
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2018-02-15";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "5ae43bb27c42387052a73e5ffc5d33efb9d946a9";
    sha256 = "1cljkkyi9dxqpqhx8y6l2ja4zjmlya26m26kqxml8gx08vyvddhx";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ python2 cairo libjpeg ntk libjack2 libsndfile
    ladspaH liblrdf liblo libsigcxx
  ];

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio Workstation";
    homepage = http://non.tuxfamily.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
