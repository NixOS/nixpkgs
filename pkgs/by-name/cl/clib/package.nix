{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
}:

stdenv.mkDerivation rec {
  version = "2.8.7";
  pname = "clib";

  src = fetchFromGitHub {
    rev = version;
    owner = "clibs";
    repo = "clib";
    sha256 = "sha256-uL8prMk2DrYLjCmZW8DdbCg5FJ5uksT3vIATyOW2ZzY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ curl ];

  meta = with lib; {
    description = "C micro-package manager";
    homepage = "https://github.com/clibs/clib";
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
