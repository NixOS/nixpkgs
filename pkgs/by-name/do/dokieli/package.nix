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
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "6f574408bc914347c3ba27869e61225fabbe6272";
    hash = "sha256-PSDsV5Gg+JT9qwMBiRkyv/ZiZY9qvqhRuKjEiPMuQDU=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-bO3yEh+P8al/oXXjqNOMOpXc0ggc17Wc00WtahniilE=";
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
