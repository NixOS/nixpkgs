{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland, scdoc
, wayland-protocols, ffmpeg, x264, libpulseaudio, ocl-icd, opencl-headers
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder-x";
  version = "20190712";

  src = fetchFromGitHub {
    owner = "schauveau";
    repo = pname;
    rev = "242fe219cc91ccc4aa54f886592b19be26c84856";
    sha256 = "0ih2ix56fc3wqwilfcb88dvnny6kc9q4df7zbfd6brw7lcyjlamn";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc ];
  buildInputs = [
    wayland-protocols ffmpeg x264 libpulseaudio ocl-icd opencl-headers
  ];

  meta = with stdenv.lib; {
    description = "An experimental fork of wf-recorder with FFMpeg filters (libavfilter)";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.linux;
  };
}
