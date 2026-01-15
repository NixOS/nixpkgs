{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  writableTmpDirAsHomeHook,
  pnpmConfigHook,
  pnpm,
  unzip,
  patchelf,
  ripgrep,
  versionCheckHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kilocode-cli";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Kilo-Org";
    repo = "kilocode";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-zEhv/tcKMR9D+aTVxaw3LBjbEBpuy4o0cpV/vowOFSY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-fTCuTAEYNyqitBvOafQyi3BDqI/O7u7yEhSPH7FVDUg=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    pnpmConfigHook
    pnpm
    nodejs
    unzip
    patchelf
  ];

  strictDeps = true;

  env.npm_config_manage_package_manager_versions = "false";

  buildPhase = ''
    runHook preBuild

    node --run cli:bundle
    touch ./cli/dist/.env

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/lib/node_modules/@kilocode/
    mv ./cli/dist $out/lib/node_modules/@kilocode/cli
    ln -s $out/lib/node_modules/@kilocode/cli/index.js $out/bin/kilocode
    chmod +x $out/bin/kilocode

    pushd $out/lib/node_modules/@kilocode/cli
    rm node_modules/@vscode/ripgrep/bin/rg
    ln -s ${ripgrep}/bin/rg node_modules/@vscode/ripgrep/bin/rg
    popd

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^cli-v(.+)$" ]; };
  };

  meta = {
    description = "Terminal User Interface for Kilo Code";
    homepage = "https://kilocode.ai/cli";
    downloadPage = "https://www.npmjs.com/package/@kilocode/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "kilocode";
  };
})
