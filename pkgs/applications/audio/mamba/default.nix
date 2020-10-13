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
  version = "1.6";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "02w47347cbfqxybh908ww5ifd9jcns8v0msycq59y9q7x0a2h6fh";
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
