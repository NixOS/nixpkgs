{ lib, stdenv, fetchFromGitHub, pkg-config, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblo, libsigcxx, lrdf, wafHook
}:

stdenv.mkDerivation {
  pname = "non";
  version = "2018-02-15";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "5ae43bb27c42387052a73e5ffc5d33efb9d946a9";
    sha256 = "1cljkkyi9dxqpqhx8y6l2ja4zjmlya26m26kqxml8gx08vyvddhx";
  };

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [ python2 cairo libjpeg ntk libjack2 libsndfile
    ladspaH liblo libsigcxx lrdf
  ];

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio Workstation";
    homepage = "http://non.tuxfamily.org";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
