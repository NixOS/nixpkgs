{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
  version = "0-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
    rev = "d6607331160574daedcde7328616123ffc939a05";
    hash = "sha256-p726AnNjv1euUUOywtI/GugJJh3Ki3I8tGJ4yfX+SD8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin {N64Recomp,RSPRecomp}
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname} ../LICENSE

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

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
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
