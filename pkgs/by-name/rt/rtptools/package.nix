{ stdenv, lib, fetchurl }:
stdenv.mkDerivation rec {
  pname = "rtptools";
  version = "1.22";
  src = fetchurl {
    url = "http://www.cs.columbia.edu/irt/software/rtptools/download/rtptools-${version}.tar.gz";
    sha256 = "0a4c0vmhxibfc58rrxpbav2bsk546chkg50ir4h3i57v4fjb4xic";
  };
  meta = {
    description = "Number of small applications that can be used for processing RTP data";
    homepage = "https://www.cs.columbia.edu/irt/software/rtptools/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
}
