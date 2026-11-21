{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitmoji-changelog";
  version = "2.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "frinyvonnick";
    repo = "gitmoji-changelog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U2BoFthnXemVj85NGCEPOtUTbFJQ1zgEJNIXEIqO768=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-d+aTvrqa02QxoyDAkHlizFbGWcVHLrRwLp45RqdFZvw=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    local packageOut="$out/lib/node_modules/gitmoji-changelog"
    mkdir -p "$packageOut"

    cp -r . "$packageOut/"

    rm -rf "$packageOut/.git"
    find "$packageOut" -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
    find "$packageOut" -type f -name "*.ts" -delete 2>/dev/null || true

    cp -r node_modules "$packageOut/"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local packageOut="$out/lib/node_modules/gitmoji-changelog"

    rm -f "$packageOut/node_modules/@gitmoji-changelog/core"
    rm -f "$packageOut/node_modules/@gitmoji-changelog/markdown"
    rm -f "$packageOut/node_modules/@gitmoji-changelog/documentation"

    ln -sf "$packageOut/packages/gitmoji-changelog-core" "$packageOut/node_modules/@gitmoji-changelog/core"
    ln -sf "$packageOut/packages/gitmoji-changelog-markdown" "$packageOut/node_modules/@gitmoji-changelog/markdown"
    ln -sf "$packageOut/packages/gitmoji-changelog-documentation" "$packageOut/node_modules/@gitmoji-changelog/documentation"

    mkdir -p "$out/bin"

    makeWrapper ${nodejs}/bin/node "$out/bin/gitmoji-changelog" \
      --add-flags "$packageOut/packages/gitmoji-changelog-cli/src/index.js" \
      --set NODE_PATH "$packageOut/node_modules"

    runHook postInstall
  '';

  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "A changelog generator based on gitmoji commits";
    homepage = "https://github.com/frinyvonnick/gitmoji-changelog";
    license = lib.licenses.mit;
    mainProgram = "gitmoji-changelog";
    maintainers = with lib.maintainers; [ Freed-Wu ];
  };
})
