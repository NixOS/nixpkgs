{ lib, fetchurl, alsa-lib, fluidsynth, libjack2, autoconf, pkg-config
, mkDerivation, qtbase, qttools, qtx11extras
}:

mkDerivation  rec {
  pname = "qsynth";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "sha256-dlgIkMde7uv4UlMKEPhtZ7MfSTBc7RvHs+Q2yk+G/JM=";
  };

  nativeBuildInputs = [ autoconf pkg-config ];

  buildInputs = [ alsa-lib fluidsynth libjack2 qtbase qttools qtx11extras ];

  enableParallelBuilding = true;
  # Missing install depends:
  #   lrelease error: Parse error at src/translations/qsynth_ru.ts:1503:33: Premature end of document.
  #   make: *** [Makefile:107: src/translations/qsynth_ru.qm] Error 1
  enableParallelInstalling = false;

  meta = with lib; {
    description = "Fluidsynth GUI";
    homepage = "https://sourceforge.net/projects/qsynth";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
