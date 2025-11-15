{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  vsce,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "vscode-icons-${finalAttrs.version}.zip";
    pname = "vscode-icons-vsix";
    version = "12.15.0";

    src = fetchFromGitHub {
      owner = "vscode-icons";
      repo = "vscode-icons";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HYMXcmK2cW01PsjwMr+SGq94oFWEXvdny6IFnXMBdKA=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-3Jt9JKbu5QxZynbkgQX/So3PWeJDdxIU5TVM4nfvgcQ=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      vsce
    ];

    env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "true";

    buildPhase = ''
      runHook preBuild
      vsce package
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp ./vscode-icons-$version.vsix $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "vscode-icons";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "vscode-icons-team";
  vscodeExtName = "vscode-icons";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.kilocode.kilo-kode.vsix";
    };
  };

  meta = {
    description = "Bring real icons to your Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons";
    homepage = "https://github.com/vscode-icons/vscode-icons";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bastaynav
      xiaoxiangmoe
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
