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
<<<<<<< HEAD
  version = "0-unstable-2025-12-16";
=======
  version = "0-unstable-2025-11-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
<<<<<<< HEAD
    rev = "5a9fa93eb670f79bb350e44c8fa850f42893a8ee";
    hash = "sha256-zqr30yjhPqpY8Iv7/Jq77iWjHiDRtEguULwtmQ13xr4=";
=======
    rev = "25c20daf88a7d7e8d816a7deed4e2fe134bdb97d";
    hash = "sha256-GiMBCUT9wd/6bZ1hXt9431Ax1Z7BLHOXfWiiPxKZsCs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
<<<<<<< HEAD
    hash = "sha256-JJ4AtggWyTjyLtZwTn6oxj1fgRd3Itv9S1/gB3XlSOI=";
=======
    hash = "sha256-8LBMHdjWaxno4I+ZAwTw9WCVotX7O0eufhGJGg1a0w4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeWrapper
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
