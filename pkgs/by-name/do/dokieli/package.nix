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
  version = "0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "dokieli";
    repo = "dokieli";
    rev = "e1de48743ace45cdbf4cc23caa902710d4a739bc";
    hash = "sha256-86MIQkXGbYGSjlgOQHxZpi35QNS5iHbYKL+3HPwdw64=";
  };

  # fails in `preInstall` without doing this
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "postinstall" "dont-postinstall"
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-snXQpcdHv/jkcFmTbjt+HrdE7gkrQqLbVv3nHDOYGW8=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  # Save space by removing non-production deps before install
  preInstall = ''
    yarn workspaces focus -A --production
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
    homepage = "https://github.com/dokieli/dokieli";
    license = lib.licenses.AND [
      lib.licenses.asl20
      lib.licenses.cc-by-40
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = [ lib.teams.ngi ];
    mainProgram = "dokieli";
  };
})
