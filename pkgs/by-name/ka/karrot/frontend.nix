{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  dart-sass,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karrot-frontend";
  version = "17.4.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "karrot";
    repo = "karrot-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p44rZOTRji1OPZwwpgo47OYYBLW4etxM/rnx1PPkxjA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-aQAeHK8vw2wJr1+qUzv1cWdm0ghzf0hHURVYepF2kpo=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    dart-sass
  ];

  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/pwa/* $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Frontend for Karrot";
    homepage = "https://codeberg.org/karrot/karrot-frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
