{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libxl";
  version = "3.9.4.3";

  src = fetchurl {
    url = "https://www.libxl.com/download/${pname}-lin-${version}.tar.gz";
    sha256 = "sha256-U8hXoqBzjSGigOXc29LZQk3KrGiYvBPBJPg5qihcAsY=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -rva include_c include_cpp license.txt $out/
    cp -rva lib64 $out/lib
  '';

<<<<<<< HEAD
  meta = {
    description = "Library for parsing Excel files";
    homepage = "https://www.libxl.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Library for parsing Excel files";
    homepage = "https://www.libxl.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
