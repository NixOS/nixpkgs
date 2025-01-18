{
  lib,
  stdenv,
  fetchurl,
  libv4l,
  gd,
}:

stdenv.mkDerivation rec {
  pname = "fswebcam";
  version = "20200725";

  src = fetchurl {
    url = "https://www.sanslogic.co.uk/fswebcam/files/fswebcam-${version}.tar.gz";
    sha256 = "1dazsrcaw9s30zz3jpxamk9lkff5dkmflp1s0jjjvdbwa0k6k6ii";
  };

  buildInputs = [
    libv4l
    gd
  ];

  meta = with lib; {
    description = "Neat and simple webcam app";
    mainProgram = "fswebcam";
    homepage = "http://www.sanslogic.co.uk/fswebcam";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
