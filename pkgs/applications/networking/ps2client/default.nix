{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  version = "unstable-2018-10-18";
  pname = "ps2client";

  src = fetchFromGitHub {
    owner = "ps2dev";
    repo  = "ps2client";
    rev = "92fcaf18aabf74daaed40bd50d428cce326a87c0";
    sha256 = "1rlmns44pxm6dkh6d3cz9sw8v7pvi53r7r5r3kgwdzkhixjj0cdg";
  };

  patchPhase = ''
   sed -i -e "s|-I/usr/include||g" -e "s|-I/usr/local/include||g" Makefile
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with lib; {
    description = "Desktop clients to interact with ps2link and ps2netfs";
    homepage = "https://github.com/ps2dev/ps2client";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
