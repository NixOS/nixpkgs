{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  pnpmBuildHook,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  runCommand,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "katex";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "katex";
    repo = "katex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z458Crgd7o68C1pKE9qf5nJhMAs5D+uyK4nbbtJO/lg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-9AZj9prk8vbt7qNCKo2yiKCvyvRbhfyFjdDU/+jNFiM=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmConfigHook
    pnpmBuildHook
  ];

  installPhase = ''
    runHook preInstall

    CI=true pnpm --ignore-scripts --prod prune

    rm -r test website fonts
    mkdir -p $out/lib/node_modules/katex/
    mkdir $out/bin
    mv * $out/lib/node_modules/katex/
    makeWrapper ${lib.getExe nodejs} $out/bin/katex \
      --add-flags "$out/lib/node_modules/katex/cli.js" \
      --set NODE_PATH "$out/lib/node_modules/katex/node_modules"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      mathml =
        runCommand "simple-mathml-output-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            echo "1+2" | katex -F mathml --output test.html
            grep -q "<semantics><mrow><mn>1</mn><mo>+</mo><mn>2</mn></mrow>" test.html
            touch $out
          '';
    };
  };

  meta = {
    changelog = "https://github.com/KaTeX/KaTeX/releases/tag/v${finalAttrs.version}";
    description = "Render TeX to HTML";
    homepage = "https://katex.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "katex";
  };
})
