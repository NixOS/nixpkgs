{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  makeWrapper,
  writeShellApplication,
  _experimental-update-script-combinators,
  nix,
  serve,
  stdenv,
  xsel,
  yarn-berry_4,
}:
let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dokieli";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "d684e852325b2247b831b179efed5d96c211f864";
    hash = "sha256-Af8KsH1tqPDuOUEaHRN3ULJwGWgZc5JgFT99sGKkkec=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-bUXAYeTJqz11Rl7vaNPNRBTqjLdSr0FrEQBAFLd9oEs=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeWrapper
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/dokieli \
      --prefix PATH : ${lib.makeBinPath [ xsel ]} \
      --chdir $out
  '';

  passthru = {
    updateScriptSrc = unstableGitUpdater { };
    updateScriptDeps = writeShellApplication {
      name = "update-dokieli-berry-deps";
      runtimeInputs = [
        nix
        yarn-berry.yarn-berry-fetcher
      ];
      text = lib.strings.readFile ./updateDeps.sh;
    };
    updateScript = _experimental-update-script-combinators.sequence [
      finalAttrs.passthru.updateScriptSrc
      (lib.getExe finalAttrs.passthru.updateScriptDeps)
    ];
  };

  meta = {
    description = "Clientside editor for decentralised article publishing, annotations and social interactions";
    homepage = "https://github.com/linkeddata/dokieli";
    license = with lib.licenses; [
      cc-by-40
      mit
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = [ lib.teams.ngi ];
    mainProgram = "dokieli";
  };
})
