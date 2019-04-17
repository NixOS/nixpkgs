{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, wayland, wayland-protocols, ffmpeg, x264 }:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "unstable-2019-03-12";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "e6ea77a2569c04975cab8655f5ad4dbcf86df1f5";
    sha256 = "1jhj5syzy8i8f9b3j4g12jmc5fcsiv4df9hgribdvw61v5pfz9g1";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ wayland wayland-protocols ffmpeg x264 ];

  meta = with stdenv.lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    homepage = https://github.com/ammen99/wf-recorder;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
