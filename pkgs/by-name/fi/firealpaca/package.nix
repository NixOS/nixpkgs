{ appimageTools, fetchurl, lib }:
let
  pname = "firealpaca";
  version = "2.12.0";
  src = fetchurl {
    url = "https://firealpaca.com/download/linux";
    sha256 = "12pn6nwzzwsf0cnm53nsmrhlv35mz34vy8x52d7bk0cn7kh6rjfh";
  };
in appimageTools.wrapType2 {
  inherit pname version src;
  meta = {
    description = "Digital Painting Software";
    homepage = "https://firealpaca.com/";
    downloadPage = "https://firealpaca.com/download";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ _34j ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
