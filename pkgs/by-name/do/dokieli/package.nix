{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
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
  version = "0-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "64374c6b9a53b68ae7921604a1fbe231d3e4f067";
    hash = "sha256-5baBKXmOxS0BOKNedMSbmw21rDBONZwmim9hlXn5OzQ=";
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

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/dokieli \
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
