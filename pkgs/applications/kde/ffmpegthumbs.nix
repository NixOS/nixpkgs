{
  mkDerivation, lib,
  extra-cmake-modules,
  ffmpeg_3, kio, taglib
}:

mkDerivation {
  pname = "ffmpegthumbs";
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ffmpeg_3 kio taglib ];
}
