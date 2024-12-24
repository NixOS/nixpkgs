{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "mkcue";
  version = "1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/m/mkcue/mkcue_${version}.orig.tar.gz";
    sha256 = "0rs897wp08z4hd904bjb5sl4lb8qxj82x5ayklr28bhg9pd5gbra";
  };

  env.CXXFLAGS = "-std=c++98";

  preInstall = "mkdir -pv $out/bin";
  postInstall = "chmod -v +w $out/bin/mkcue";

  meta = with lib; {
    description = "Generates CUE sheets from a CD TOC";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "mkcue";
  };
}
