{
  mkDerivation,
  lib,
  extra-cmake-modules,
  ffmpeg,
  kio,
  taglib,
}:

mkDerivation {
  pname = "ffmpegthumbs";
  meta = with lib; {
    license = with licenses; [
      gpl2
      bsd3
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    ffmpeg
    kio
    taglib
  ];
}
