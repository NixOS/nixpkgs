{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
}:
stdenv.mkDerivation rec {
  pname = "fna3d";
  version = "25.02";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-0rRwIbOciPepo+ApvJiK5IyhMdq/4jsMlCSv0UeDETs=";
  };

  buildInputs = [ SDL2 ];
  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall
    install -Dm755 libFNA3D.so $out/lib/libFNA3D.so
    ln -s libFNA3D.so $out/lib/libFNA3D.so.0
    ln -s libFNA3D.so $out/lib/libFNA3D.so.0.${version}
    runHook postInstall
  '';

  meta = {
    description = "Accuracy-focused XNA4 reimplementation for open platforms";
    homepage = "https://fna-xna.github.io/";
    license = lib.licenses.mspl;
    platforms = lib.platforms.linux;
    mainProgram = "fna3d";
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
}
