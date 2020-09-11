{ stdenv
, fetchFromGitHub
, pkg-config
, cairo
, fluidsynth
, libX11
, libjack2
, liblo
, libsigcxx
, libsmf
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "08dcm0mmka1lbssrgck66v9l2rk3r4y63ij06aw2f9la8a84y20j";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo fluidsynth libX11 libjack2 liblo libsigcxx libsmf ];

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
