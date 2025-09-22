{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libestr";
  version = "0.1.11";

  src = fetchurl {
    url = "http://libestr.adiscon.com/files/download/${pname}-${version}.tar.gz";
    sha256 = "0910ifzcs8kpd3srrr4fvbacgh2zrc6yn7i4rwfj6jpzhlkjnqs6";
  };

  meta = with lib; {
    homepage = "https://libestr.adiscon.com/";
    description = "Some essentials for string handling";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
