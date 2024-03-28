{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
}:
stdenv.mkDerivation rec {
  pname = "fna3d";
  version = "23.11";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-UXphZQrk+MUOcUIqZ0ho3HTP5vNZjN9ifsANOJbTfVE=";
  };

  buildInputs = [ cmake SDL2 ];

  installPhase = ''
    runHook preInstall
    install -Dm755 libFNA3D.so $out/lib/libFNA3D.so
    ln -s $out/lib/libFNA3D.so $out/lib/libFNA3D.so.0
    ln -s $out/lib/libFNA3D.so $out/lib/libFNA3D.so.0.${version}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Accuracy-focused XNA4 reimplementation for open platforms";
    homepage = "https://fna-xna.github.io/";
    license = licenses.mspl;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = with maintainers; [ mrtnvgr ];
  };
}
