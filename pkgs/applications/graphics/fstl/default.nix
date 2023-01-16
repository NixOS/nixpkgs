{ lib, stdenv, fetchFromGitHub, mkDerivation, qtbase, cmake }:

mkDerivation rec {
  pname = "fstl";
  version = "0.10.0";

  buildInputs = [qtbase cmake];

  installPhase = lib.optionalString stdenv.isDarwin ''
    cd ../app
    ./package.sh
    mkdir -p $out/Applications
    mv fstl.app $out/Applications
  '';

  src = fetchFromGitHub {
    owner = "mkeeter";
    repo = "fstl";
    rev = "v" + version;
    sha256 = "sha256-z2X78GW/IeiPCnwkeLBCLjILhfMe2sT3V9Gbw4TSf4c=";
  };

  meta = with lib; {
    description = "The fastest STL file viewer";
    homepage = "https://github.com/mkeeter/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
