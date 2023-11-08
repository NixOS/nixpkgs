{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
}:
stdenv.mkDerivation rec {
  pname = "fna3d";
  version = "24.11";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-NTVaPY39acSRibGQjLuh5ZBGC1Zep/rybVcOU0WrNIw=";
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
    mainProgram = pname;
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
}
