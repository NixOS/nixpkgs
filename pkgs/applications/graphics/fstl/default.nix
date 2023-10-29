{ lib, stdenv, fetchFromGitHub, mkDerivation, cmake }:

mkDerivation rec {
  pname = "fstl";
  version = "0.10.0";

  buildInputs = [ cmake ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv fstl.app $out/Applications
  '';

  src = fetchFromGitHub {
    owner = "fstl-app";
    repo = "fstl";
    rev = "v" + version;
    sha256 = "sha256-z2X78GW/IeiPCnwkeLBCLjILhfMe2sT3V9Gbw4TSf4c=";
  };

  meta = with lib; {
    description = "The fastest STL file viewer";
    homepage = "https://github.com/fstl-app/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
