{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "matrix";
  version = "0-unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "wick3dr0se";
    repo = "matrix";
    rev = "132403458b7cff2287edd2c404cfdefe327b276b";
    hash = "sha256-0PFaCLhs2xBYhpIyzd5PM05gNkQdiVZjOl7iTXnGFCU=";
  };

  installPhase = ''
    runHook preInstall

    install -D matrix --target-directory=$out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix digital rain implemented in Bash";
    homepage = "https://github.com/wick3dr0se/matrix";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "matrix";
    platforms = lib.platforms.all;
  };
}
