{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  vscode-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = "1.103.2";
    hash = "sha256-DEU0+lFNzH2CC8crRmZidJrANa88eL2ej/WZ28Lh/eo=";
  };
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "gitlens-${finalAttrs.version}.vsix";
    pname = "gitlens-vsix";
    version = "17.4.1";

    src = fetchFromGitHub {
      owner = "gitkraken";
      repo = "vscode-gitlens";
      tag = "v${finalAttrs.version}";
      hash = "sha256-BMfFvqQL88KYZQ0STgy2eOn/aK9ap+ResA9Hvih9lZc=";
    };

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-DsFZdjSkN6aYg6nJATw+IBi8zX2CUaqbs2BhYAcfjVc=";
    };

    postPatch = ''
      substituteInPlace scripts/generateLicenses.mjs --replace-fail 'https://raw.github.com/microsoft/vscode/main/LICENSE.txt' '${vscode-src}/LICENSE.txt'
    '';

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      pnpm
    ];

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

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

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
