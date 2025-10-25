{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "dos2unix";
  version = "7.5.3";

  src = fetchurl {
    url = "https://waterlan.home.xs4all.nl/dos2unix/${pname}-${version}.tar.gz";
    sha256 = "sha256-KKSw2fkXnaTkTFZ7nAH4GLBwoggnEV//2W92Dc+g87I=";
  };

  nativeBuildInputs = [
    perl
    gettext
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa";
    homepage = "https://waterlan.home.xs4all.nl/dos2unix.html";
    changelog = "https://sourceforge.net/p/dos2unix/dos2unix/ci/dos2unix-${version}/tree/dos2unix/NEWS.txt?format=raw";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ c0bw3b ];
    platforms = lib.platforms.all;
  };
}
