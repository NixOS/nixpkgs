{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
    rev = "6eb7d5bd3ee7f0b79f3fd7adbe931dccbacf7e1b";
    hash = "sha256-NiB3fhlm/hZsQD0QfqMOSk/LfNCCFmIWkjwRGIJ9bzA=";
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

      # Mark as unfree for now
      # Need clarification regarding the derivations of reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "N64Recomp";
    platforms = [ "x86_64-linux" ];
  };
})
