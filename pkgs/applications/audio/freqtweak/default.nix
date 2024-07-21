{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, fftwFloat, libjack2, libsigcxx, libxml2, wxGTK }:

stdenv.mkDerivation rec {
  pname = "freqtweak";
  version = "unstable-2019-08-03";

  src = fetchFromGitHub {
    owner = "essej";
    repo = pname;
    rev = "d4205337558d36657a4ee6b3afb29358aa18c0fd";
    sha256 = "10cq27mdgrrc54a40al9ahi0wqd0p2c1wxbdg518q8pzfxaxs5fi";
  };

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ fftwFloat libjack2 libsigcxx libxml2 wxGTK ];

  preConfigure = ''
    sh autogen.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://essej.net/freqtweak/";
    description = "Realtime audio frequency spectral manipulation";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "freqtweak";
  };
}
