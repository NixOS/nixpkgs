{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, fastfetch
}:

stdenv.mkDerivation rec {
  pname = "fetch-3d";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "areofyl";
    repo = "fetch";
    rev = "master";
    hash = "sha256-ybqmVtCAtP0Pg8ZmrW/boVUMnTfe4o+D9eAy/unqZ1w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ fastfetch ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make install PREFIX=$out
    
    wrapProgram $out/bin/fetch \
      --prefix PATH : ${lib.makeBinPath [ fastfetch ]}
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