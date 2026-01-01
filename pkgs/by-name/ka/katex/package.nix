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
<<<<<<< HEAD
  version = "0.16.27";
=======
  version = "0.16.25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "katex";
    repo = "katex";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-bw5W8TkM31aeqQ6eJae8voW75RvvUjeTdu7aPQ+lAa0=";
=======
    hash = "sha256-XwKjoXkn96YNxrBv2qcUSqKMtHxz9+levevc4Rz1SYw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
<<<<<<< HEAD
    hash = "sha256-bRzYuiYDAz9LTcaUgI0dvfxU/eo0uTSz0pPP7dH5XW8=";
=======
    hash = "sha256-vPYzt+ZBbi1sR7T1I08f/syTnN8hnUTqH4fKCBiFIM0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
