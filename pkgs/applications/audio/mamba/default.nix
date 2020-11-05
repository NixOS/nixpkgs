{ stdenv
, fetchFromGitHub
, pkg-config
, cairo
, fluidsynth
, libX11
, libjack2
, alsaLib
, liblo
, libsigcxx
, libsmf
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "1i78snpyxap2r4899967nyfr8hg20k45nsbshs9h6hdxbfwhikbc";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo fluidsynth libX11 libjack2 alsaLib liblo libsigcxx libsmf ];

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
