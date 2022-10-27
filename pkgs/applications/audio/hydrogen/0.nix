{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, alsa-lib
, boost
, glib
, lash
, libjack2
, libarchive
, libsndfile
, lrdf
, qt4
}:

stdenv.mkDerivation rec {
  version = "0.9.7";
  pname = "hydrogen";

  src = fetchFromGitHub {
    owner = "hydrogen-music";
    repo = "hydrogen";
    rev = version;
    sha256 = "sha256-6ycNUcumtAEl/6XbIpW6JglGv4nNOdMrOJ1nvJg3z/c=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    alsa-lib
    boost
    glib
    lash
    libjack2
    libarchive
    libsndfile
    lrdf
    qt4
  ];

  meta = with lib; {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
