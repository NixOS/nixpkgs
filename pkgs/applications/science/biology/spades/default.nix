{ lib, stdenv, fetchurl, zlib, bzip2, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "SPAdes";
  version = "3.15.3";

  src = fetchurl {
    url = "http://cab.spbu.ru/files/release${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-suWp/XplruWriGIi1q9Pe3vH91XaegOUFXH6vWueFJk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib bzip2 python3 ];

  doCheck = true;

  sourceRoot = "${pname}-${version}/src";

  meta = with lib; {
    description = "St. Petersburg genome assembler: assembly toolkit containing various assembly pipelines";
    license = licenses.gpl2Only;
    homepage = "http://cab.spbu.ru/software/spades/";
    platforms = with platforms; [ "x86_64-linux" "x86_64-darwin"];
    maintainers = [ maintainers.bzizou ];
  };
}
