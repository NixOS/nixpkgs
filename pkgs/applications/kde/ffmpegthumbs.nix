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
  meta = {
    license = with lib.licenses; [
      gpl2
      bsd3
    ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    ffmpeg
    kio
    taglib
  ];
}
