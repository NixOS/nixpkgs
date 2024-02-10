{ mkDerivation, lib, fetchurl, pkg-config, ffmpeg_4, glew, libass, openal, qtbase }:

mkDerivation rec {
  pname = "bino";
  version = "1.6.8";

  src = fetchurl {
    url = "https://bino3d.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-8sIdX+qm7CGPHIziFBHHIe+KEbhbwDY6w/iRm1V+so4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg_4 glew libass openal qtbase ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Stereoscopic 3D and multi-display video player";
    homepage = "https://bino3d.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    mainProgram = "bino";
  };
}
