{
  bun,
  lib,
  fetchFromGitHub,
  mystmd,
  nodejs,
  stdenv,
  testers,
  nix-update-script,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mystmd";
  version = "1.12.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "mystmd";
    tag = "mystmd@${finalAttrs.version}";
    hash = "sha256-iIBjXkObnZ8N6U2QF2jr/ctPxTud1gjxL3I1B6MDEWU=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-node_modules";

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
      makeWrapper
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      # only the root node_modules is copied out; upstream defaults to isolated
      bun install --no-progress --frozen-lockfile --no-cache --linker=hoisted

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      {
        x86_64-linux = "sha256-mUJZDaFKPTci/Wq3lnXrh3tzfjpsybW/EyRVmftV0HE=";
        aarch64-linux = "sha256-W/wTX4Yp4a+qnlZfb3Z7UnuXa2BgjcNp/WmI6TSiY5c=";
        aarch64-darwin = "sha256-RqBSDEnA4M6KFfQXIv6QnrW+TFcEMW00AWQ9XgdnkCc=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs
    makeWrapper
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    chmod -R +w ./node_modules
    bun prune --production
    # link to the docs workspace, which isn't installed
    rm node_modules/mystmd-docs
    mkdir -p $out/lib
    cp -r node_modules $out/lib/
    cp -r packages $out/lib/
    install -D packages/mystmd/dist/myst.cjs $out/bin/myst
    wrapProgram $out/bin/myst --prefix PATH : ${lib.makeBinPath [ nodejs ]}
    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command line tools for working with MyST Markdown";
    homepage = "https://github.com/jupyter-book/mystmd";
    changelog = "https://github.com/jupyter-book/mystmd/blob/${finalAttrs.src.rev}/packages/myst-cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "myst";
  };
})
