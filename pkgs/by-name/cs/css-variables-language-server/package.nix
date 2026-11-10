{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libsecret,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "css-variables-language-server";
  version = "2.8.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vunguyentuan";
    repo = "vscode-css-variables";
    tag = "css-variables-language-server@${finalAttrs.version}";
    hash = "sha256-NdacBF8sUOij6k4AkMim93LrBJi8JL43q/N8GryTXHA=";
  };

  npmDepsHash = "sha256-9iPS7/fiJFBFlqt71q5i9rY0lc3tqYeAddb+oB1uxZc=";
  npmDepsFetcherVersion = 2;
  npmWorkspace = "packages/css-variables-language-server";

  npmPruneFlags = [
    "--include-workspace-root=false"
  ];

  npmInstallFlags = [
    "--workspace=packages/css-variables-language-server"
    "--include-workspace-root=false"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin

    cp -r node_modules $out/lib
    cp -r packages $out/lib

    makeWrapper ${nodejs}/bin/node $out/bin/css-variables-language-server --add-flags "$out/lib/packages/css-variables-language-server/dist/index.js"

    runHook postInstall
  '';

  meta = {
    description = "CSS Variables Language Server in node";
    changelog = "https://github.com/vunguyentuan/vscode-css-variables/releases/tag/css-variables-language-server@${finalAttrs.version}";
    homepage = "https://github.com/vunguyentuan/vscode-css-variables";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aiwao ];
    mainProgram = "css-variables-language-server";
  };
})
