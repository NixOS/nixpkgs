{ mkDerivation, lib, fetchurl, pkg-config, qtbase, qttools, libjack2, alsa-lib, liblo, lv2 }:

mkDerivation rec {
  pname = "synthv1";
  version = "0.9.23";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${pname}-${version}.tar.gz";
    sha256 = "sha256-0V72T51icT/t9fJf4mwcMYZLjzTPnmiCbU+BdwnCmw4=";
  };

  buildInputs = [ qtbase qttools libjack2 alsa-lib liblo lv2 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    mainProgram = "synthv1_jack";
    homepage = "https://synthv1.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
