{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
  version = "0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
    rev = "ba4aede49c9a5302ecfc1fa599f7acc3925042f9";
    hash = "sha256-9C5mbDlj2gh2hFKm7+UoFLlkzoEzTf6wk5rizzwOUzc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin N64Recomp
    install -Dm755 -t $out/bin RSPRecomp

    runHook postInstall
  '';

  meta = {
    description = "Tool to statically recompile N64 games into native executables";
    homepage = "https://github.com/N64Recomp/N64Recomp";
    license = with lib.licenses; [
      # N64Recomp
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "N64Recomp";
    platforms = [ "x86_64-linux" ];
  };
})
