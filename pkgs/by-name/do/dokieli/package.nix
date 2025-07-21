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
  version = "0-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "13c0c2d2d307ab1f391aca9aec4efc4ac4ba43c5";
    hash = "sha256-V9tKoSu1r8LZaIZUu1JSyZ0dM7/zblTDQZHu86/V3LE=";
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
