{
  lib,
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "gitlens-${finalAttrs.version}.zip";
    pname = "gitlens-vsix";
    version = "17.5.1";

    src = fetchFromGitHub {
      owner = "gitkraken";
      repo = "vscode-gitlens";
      tag = "v${finalAttrs.version}";
      hash = "sha256-DGV4liUpJNM6ktMy3jQ1iEQ7H5mPM17f0uqA8QYHoLc=";
    };

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-Lx8YRG3B3t83t85PqDMevIm7M0ks2IsluwL1I5zThdA=";
    };

    postPatch = ''
      substituteInPlace scripts/generateLicenses.mjs --replace-fail 'https://raw.githubusercontent.com/microsoft/vscode/refs/heads/main/LICENSE.txt' '${pkgs.vscode-json-languageserver.src}/LICENSE.txt'
    '';

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      pnpm
    ];

    # Error: spawn /build/source/node_modules/.pnpm/sass-embedded-linux-x64@1.77.8/node_modules/sass-embedded-linux-x64/dart-sass/src/dart ENOENT
    # Remove both node_modules/.pnpm/sass-embedded and node_modules/.pnpm/sass-embedded-linux-x64
    preBuild = ''
      rm -r node_modules/.pnpm/sass-embedded*
    '';

    buildPhase = ''
      runHook preBuild

      node --run package

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp ./gitlens-$version.vsix $out

      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "gitlens";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "eamodio";
  vscodeExtName = "gitlens";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.eamodio.gitlens.vsix";
    };
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
    description = "Visual Studio Code extension that improves its built-in Git capabilities";
    longDescription = ''
      Supercharge the Git capabilities built into Visual Studio Code — Visualize code authorship at a glance via Git
      blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via
      powerful comparison commands, and so much more
    '';
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens";
    homepage = "https://gitlens.amod.io/";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      ratsclub
    ];
  };
})
