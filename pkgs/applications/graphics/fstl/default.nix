{ lib, stdenv, fetchFromGitHub, mkDerivation, cmake }:

mkDerivation rec {
  pname = "fstl";
  version = "0.10.0";

  nativeBuildInputs = [ cmake ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    mv fstl.app $out/Applications

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "fstl-app";
    repo = "fstl";
    rev = "v" + version;
    hash = "sha256-z2X78GW/IeiPCnwkeLBCLjILhfMe2sT3V9Gbw4TSf4c=";
  };

  meta = with lib; {
    description = "The fastest STL file viewer";
    homepage = "https://github.com/fstl-app/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
