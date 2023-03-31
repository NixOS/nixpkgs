{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dra";
  version = "unstable-2022-08-13";

  src = fetchFromGitHub {
    owner = "eastrocky";
    repo = pname;
    rev = "9913d33ed811c24da5cb0a4221adde42edf6c174";
    sha256 = "ecO268N6Ld60RZdwF6ZlDBf0yJHTqCDE9y5DySwBPJI=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Douay-Rheims 1899 American Edition Bible on the Command Line";
    homepage = "https://github.com/eastrocky/dra";
    license = licenses.publicDomain;
    maintainers = [ maintainers.mertzenich ];
  };
}
