{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "rgxg";
  version = "0.1.2";

  src = fetchzip {
    url = "https://github.com/rgxg/rgxg/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "050jxc3qhfrm9fdbzd67hlsqlp4qk1fa20q1g2v919sh7s6v77si";
  };

<<<<<<< HEAD
  meta = {
    description = "C library and a command-line tool to generate (extended) regular expressions";
    mainProgram = "rgxg";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ hloeffler ];
=======
  meta = with lib; {
    description = "C library and a command-line tool to generate (extended) regular expressions";
    mainProgram = "rgxg";
    license = licenses.zlib;
    maintainers = with maintainers; [ hloeffler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://rgxg.github.io/";
  };
}
