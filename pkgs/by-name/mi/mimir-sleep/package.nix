{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  bashNonInteractive,
  gawk,
  sox,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mimir-sleep";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "FraioVeio";
    repo = "mimir";
    rev = finalAttrs.version;
    hash = "sha256-TahlhXE5BWGGL2AKmgiAdruUkNgQSId/QwoJEfplHCc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashNonInteractive ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 mimir.sh "$out/bin/mimir"
    install -Dm444 -t "$out/share/mimir" mimir/esleep1.wav mimir/esleep2.wav

    patchShebangs "$out/bin/mimir"
    wrapProgram "$out/bin/mimir" \
      --prefix PATH : ${
        lib.makeBinPath [
          gawk
          sox
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Drop-in `sleep` replacement that plays soothing sound effects while your computer is asleep";
    homepage = "https://github.com/FraioVeio/mimir";
    changelog = "https://github.com/FraioVeio/mimir/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fraioveio ];
    platforms = lib.platforms.unix;
    mainProgram = "mimir";
  };
})
