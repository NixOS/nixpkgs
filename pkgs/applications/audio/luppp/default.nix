{ stdenv
, fetchFromGitHub
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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-Luppp";
    rev = "release-${version}";
    sha256 = "1ncbn099fyfnr7jw2bp3wf2g9k738lw53m6ssw6wji2wxwmghv78";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    jack2
    cairo
    liblo
    libsndfile
    libsamplerate
    ntk
  ];

  meta = with stdenv.lib; {
    homepage = "http://openavproductions.com/luppp/";  # https does not work
    description = "A music creation tool, intended for live use";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux;
  };
}
