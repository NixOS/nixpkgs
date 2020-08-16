{ stdenv
, fetchFromGitHub
, pkgconfig
, cairo
, libX11
, libjack2
, liblo
, libsigcxx
, libsmf
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "1wa3f9c4l239mpxa7nxx8hajy4icn40vpvaxq5l1qzskl74w072d";
    fetchSubmodules = true;
  };

  patches = [ ./fix-build.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo libX11 libjack2 liblo libsigcxx libsmf ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/brummer10/Mamba";
    description = "Virtual MIDI keyboard for Jack Audio Connection Kit";
    license = licenses.bsd0;
    maintainers = with maintainers; [ magnetophon orivej ];
    platforms = platforms.linux;
  };
}
