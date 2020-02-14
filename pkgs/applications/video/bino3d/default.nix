{ mkDerivation, lib, fetchurl, pkgconfig, ffmpeg, glew, libass, openal, qtbase }:

mkDerivation rec {
  pname = "bino";
  version = "1.6.7";

  src = fetchurl {
    url = "https://bino3d.org/releases/${pname}-${version}.tar.xz";
    sha256 = "04yl7ibnhajlli4a5x77az8jxbzw6b2wjay8aa6px551nmiszn9k";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ ffmpeg glew libass openal qtbase ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Stereoscopic 3D and multi-display video player";
    homepage = https://bino3d.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
