{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  npmHooks,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bwrb";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "3mdistal";
    repo = "bwrb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-24e7HMlbSnyJ0hk345hPojKXci/8d/mt0w+kHowF0Kc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-tQnB4ZK/METdbKygyJOS2evT5vW3kQz7RipSpFgKfjI=";
  };

  postPatch = ''
    node -e 'const fs = require("fs"); const pkg = JSON.parse(fs.readFileSync("package.json", "utf8")); delete pkg.packageManager; fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));'
  '';

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm
    npmHooks.npmInstallHook
  ];

  preConfigure = ''
    export HOME="$TMPDIR"
    export XDG_CACHE_HOME="$TMPDIR"
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  dontNpmPrune = true;

  meta = {
    description = "Schema-driven note management for markdown vaults";
    homepage = "https://github.com/3mdistal/bwrb";
    changelog = "https://github.com/3mdistal/bwrb/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3mdistal ];
    mainProgram = "bwrb";
    platforms = nodejs_22.meta.platforms;
  };
})
