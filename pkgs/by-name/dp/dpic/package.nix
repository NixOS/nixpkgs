{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dpic";
  version = "2024.01.01";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/${pname}-${version}.tar.gz";
    sha256 = "sha256-FhkBrJr4bXMFUSuhtWSUBPtMgDoPqwYmJ8w8WJWthy8=";
  };

  # The prefix passed to configure is not used.
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Implementation of the pic little language for creating drawings";
    homepage = "https://ece.uwaterloo.ca/~aplevich/dpic/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aespinosa ];
    platforms = lib.platforms.all;
    mainProgram = "dpic";
  };
}
