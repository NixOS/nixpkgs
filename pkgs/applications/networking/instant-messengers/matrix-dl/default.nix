{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "matrix-dl-unstable";
  version = "2019-09-22";

  src = fetchFromGitHub {
    owner = "rubo77";
    repo = "matrix-dl";
    rev = "e91610f45b7b3b0aca34923309fc83ba377f8a69";
    sha256 = "036xfdd21pcfjlilknc67z5jqpk0vz07853wwcsiac32iypc6f2q";
  };

  propagatedBuildInputs = with python3Packages; [
    matrix-client
  ];

  meta = with lib; {
    description = "Download backlogs from Matrix as raw text";
    homepage = src.meta.homepage;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ aw ];
    platforms = platforms.unix;
  };
}
