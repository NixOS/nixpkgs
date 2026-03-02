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
  version = "0-unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "6642119c67d1e202998d4e3fa12d06f672307bcb";
    hash = "sha256-nzWPflazU0ZgQwYFivvbjuMtQ/6JHFwBlmkPPfdLAcI=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-kXNev+L8DvDm8kUrCEWOSp7Es3WnCL3kfDLozrZ5/1U=";
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
