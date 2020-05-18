{
  mkDerivation, lib,
  extra-cmake-modules,
  ffmpeg, kio
}:

mkDerivation {
  name = "ffmpegthumbs";
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ffmpeg kio ];
}
