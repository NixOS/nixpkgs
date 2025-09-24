{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "stricat";
  version = "20140609100300";

  src = fetchurl {
    url = "http://www.stribob.com/dist/${pname}-${version}.tgz";
    sha256 = "1axg8r4g5n5kdqj5013pgck80nni3z172xkg506vz4zx1zcmrm4r";
  };

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p $out/bin
    mv stricat $out/bin
  '';

  meta = {
    description = "Multi-use cryptographic tool based on the STRIBOB algorithm";
    homepage = "https://www.stribob.com/stricat/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
    mainProgram = "stricat";
  };
}
