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

  meta = {
    description = "Neat and simple webcam app";
    mainProgram = "fswebcam";
    homepage = "http://www.sanslogic.co.uk/fswebcam";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
