{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "safefile";
  version = "1.0.5";

  src = fetchurl {
    url = "https://research.cs.wisc.edu/mist/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    description = "File open routines to safely open a file when in the presence of an attack";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    homepage = "https://research.cs.wisc.edu/mist/safefile/";
  };
}
