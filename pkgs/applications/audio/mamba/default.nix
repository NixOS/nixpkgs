{ lib, stdenv
, fetchFromGitHub
, pkg-config
, xxd
, cairo
, fluidsynth
, libX11
, libjack2
, alsa-lib
, liblo
, libsigcxx
, libsmf
}:

stdenv.mkDerivation rec {
  pname = "mamba";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Mamba";
    rev = "v${version}";
    sha256 = "1885qxyfkpslzk0aaaaws0x73b10h9nbr04jkk7xhkya25gf280m";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config xxd ];
  buildInputs = [ cairo fluidsynth libX11 libjack2 alsa-lib liblo libsigcxx libsmf ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/brummer10/Mamba";
    description = "Virtual MIDI keyboard for Jack Audio Connection Kit";
    license = licenses.bsd0;
    maintainers = with maintainers; [ magnetophon orivej ];
    platforms = platforms.linux;
  };
}
