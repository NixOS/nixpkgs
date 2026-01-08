{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gawk,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "awkaster";
  version = "0-unstable-2023-01-20";

  src = fetchFromGitHub {
    owner = "TheMozg";
    repo = "awk-raycaster";
    rev = "ac7f1b03554ca1c662ea2951cdd9f0b586075890";
    hash = "sha256-g8jrVCQsdEASzE0HUpACQIhMslXbBpMH9Z7+rYVwEqg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 awkaster.awk "$out/share/awkaster/awkaster.awk"
    install -Dm644 README.md -t "$out/share/doc/awkaster"
    install -Dm644 LICENSE -t "$out/share/licenses/awkaster"

    makeWrapper ${gawk}/bin/gawk "$out/bin/awkaster" \
      --add-flags "-f $out/share/awkaster/awkaster.awk"

    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    printf "q" | "$out/bin/awkaster" | grep -Fq "You quit."

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Awk-based pseudo-3D dungeon game inspired by Wolfenstein 3D";
    homepage = "https://github.com/TheMozg/awk-raycaster";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "awkaster";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
