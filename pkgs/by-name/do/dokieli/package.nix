{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodePackages,
  stdenv,
  xsel,
  yarn-berry_4,
}:
let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dokieli";
  version = "0-unstable-2025-07-06";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "825d3aa5d754b512f8cbde2cc504b1d00788022c";
    hash = "sha256-ZjsRG+qIzRb+8FM7a4qSkahxQeq1ayXSgD/oo7jdi6w=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-4SK1ecjEnnaow5Z2biCPaHirpX6J/5cytQWWicPgmB0=";
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

  postFixup =
    let
      serve = lib.getExe' nodePackages.serve "serve";
    in
    ''
      makeWrapper ${serve} $out/bin/dokieli \
        --prefix PATH : ${lib.makeBinPath [ xsel ]} \
        --chdir $out
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
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
