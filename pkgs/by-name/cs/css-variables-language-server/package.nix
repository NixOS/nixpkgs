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

  npmDepsHash = "sha256-cgX/M05UGsx87QO/Ge0VCD2hQ9MkfJarJVNCj/IcnM0=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libsecret
  ];

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r node_modules $out/lib
    cp -r packages $out/lib

    makeWrapper ${nodejs}/bin/node $out/bin/index.js --add-flags "$out/lib/packages/css-variables-language-server/dist/index.js"

    mv $out/bin/index.js $out/bin/css-variables-language-server

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
