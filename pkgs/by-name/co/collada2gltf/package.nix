{
  fetchFromGitHub,
  gcc10Stdenv,
  lib,
  cmake,
}:
gcc10Stdenv.mkDerivation rec {
  pname = "COLLADA2GLTF";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "COLLADA2GLTF";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Eo1qS6S5vlc/d2WB4iDJTjUnwMUrx9+Ln6n8PYU5qA=";
    fetchSubmodules = true;
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 COLLADA2GLTF-bin $out/bin/COLLADA2GLTF

    runHook postInstall
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Command-line tool to convert COLLADA (.dae) files to glTF";
    homepage = "https://github.com/KhronosGroup/COLLADA2GLTF";
    license = lib.licenses.bsd3;
    mainProgram = "COLLADA2GLTF";
    maintainers = with lib.maintainers; [ shaddydc ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
