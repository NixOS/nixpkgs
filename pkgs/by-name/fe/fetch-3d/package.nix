{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "fetch-3d";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "areofyl";
    repo = "fetch";
    rev = "master";
    sha256 = "08ky9k6l6pd5di0caj3a3naz2bafpjf4rqyvh0bnl6czww6632p4";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    description = "An animated 3D fetch tool for your terminal";
    homepage = "https://github.com/areofyl/fetch";
    license = licenses.isc;
    platforms = platforms.linux;
    mainProgram = "fetch";
    maintainers = with maintainers; [ red-hood-woods ]; 
  };
}
