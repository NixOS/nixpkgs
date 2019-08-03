{ stdenv, fetchFromGitHub
, meson
, ninja
, pkgconfig
, jack2
, cairo
, liblo
, libsndfile
, libsamplerate
, ntk
}:

stdenv.mkDerivation rec {
  pname = "luppp";
  version = "1.2.0";
  patches = [ ./build-install.patch ];

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-Luppp";
    rev = "release-${version}";
    sha256 = "194yq0lqc2psq9vyxmzif40ccawcvd9jndcn18mkz4f8h5w5rc1a";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
  ];

  buildInputs = [
    jack2 cairo liblo libsndfile libsamplerate ntk
  ];

  meta = with stdenv.lib; {
    homepage = http://openavproductions.com/luppp/;
    description = "A music creation tool, intended for live use";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux;
  };
}
