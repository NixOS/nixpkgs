{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "vdmfec";
  version = "1.0";

  src = fetchurl {
    url = "http://members.tripod.com/professor_tom/archives/${pname}-${version}.tgz";
    sha256 = "0i7q4ylx2xmzzq778anpkj4nqir5gf573n1lbpxnbc10ymsjq2rm";
  };

  meta = with lib; {
    description = "A program that adds error correction blocks";
    homepage = "http://members.tripod.com/professor_tom/archives/index.html";
    maintainers = [ maintainers.ar1a ];
    license = with licenses; [
      gpl2 # for vdmfec
      bsd2 # for fec
    ];
    platforms = platforms.all;
  };
}
