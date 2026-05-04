{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katex";
  version = "0.16.28";

  src = fetchFromGitHub {
    owner = "katex";
    repo = "katex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M9PqzSQkMcnfuL2n/eLwxnk3E9gSEVu0t6Tahiw7niI=";
  };

  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/KaTeX/KaTeX/blob/main/package.json#L58
    ./yarn-4.14-support.patch
  ];

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-6DxF+TtUOqW14ivBHETUMXzDspP/54k1OzbKeIJqDAQ=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    nodejs
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn config set nodeLinker "node-modules"
    yarn install --mode=skip-build --inline-builds
    mkdir -p $out/lib/node_modules/katex/
    mkdir $out/bin
    mv * $out/lib/node_modules/katex/
    makeWrapper ${lib.getExe nodejs} $out/bin/katex \
      --add-flags "$out/lib/node_modules/katex/cli.js" \
      --set NODE_PATH "$out/lib/node_modules/katex/node_modules"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/KaTeX/KaTeX/releases/tag/v${finalAttrs.version}";
    description = "Render TeX to HTML";
    homepage = "https://katex.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "katex";
  };
})
