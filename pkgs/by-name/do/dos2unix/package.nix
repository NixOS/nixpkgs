{lib, stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  pname = "dos2unix";
  version = "7.5.2";

  src = fetchurl {
    url = "https://waterlan.home.xs4all.nl/dos2unix/${pname}-${version}.tar.gz";
    sha256 = "sha256-JkdCRGYIRC60j5bCCvbaMDyzqSs2TnLLfiT4gjnEvzo=";
  };

  nativeBuildInputs = [ perl gettext ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa";
    homepage = "https://waterlan.home.xs4all.nl/dos2unix.html";
    changelog = "https://sourceforge.net/p/dos2unix/dos2unix/ci/dos2unix-${version}/tree/dos2unix/NEWS.txt?format=raw";
    license = licenses.bsd2;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
