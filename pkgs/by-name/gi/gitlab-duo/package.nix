{
  buildNpmPackage,
  bun,
  concurrently,
  fetchFromGitLab,
  lib,
  nodejs_22,
  patch-package,
  stdenv,
  versionCheckHook,
  ripgrep,
}:
buildNpmPackage (finalAttrs: {
  pname = "gitlab-duo";
  version = "8.89.0";

  # DOCS https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp#node-version
  nodejs = nodejs_22;

  src = fetchFromGitLab {
    group = "gitlab-org";
    owner = "editor-extensions";
    repo = "gitlab-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AiC0xxk8d/2rvRGm31vWqRuJ7nzMrITTGabv7v1LpOA=";
  };

  patches = [
    # HACK https://github.com/NixOS/nixpkgs/issues/408720
    # Fix packages locked but without hash, or even missing
    ./missing-hashes.patch
  ];

  npmFlags = [ "--install-links" ];
  npmDepsHash = "sha256-U/dwfYZqy/1CM+Emz1w44mAzY24Z8vKWBXSzSqeVmnY=";
  npmRebuildFlags = [ "--ignore-scripts" ];
  npmBuildScript = "build:binary";
  npmWorkspace = "@gitlab/duo-cli";
  nativeBuildInputs = [
    bun
    concurrently
    patch-package
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "true";
  env.PUPPETEER_SKIP_DOWNLOAD = "true";
  env.TARGET = "${stdenv.targetPlatform.node.platform}-${stdenv.targetPlatform.node.arch}";
  env.SUPPORTED_TARGETS = "bun-${stdenv.targetPlatform.node.platform}-${stdenv.targetPlatform.node.arch}";
  env.SKIP_RIPGREP_BUNDLE = 1;

  postConfigure = ''
    patchShebangs --build ./packages/cli/scripts
    npmBuildScript=build:bundle runHook npmBuildHook
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 packages/cli/bin/duo-$TARGET $out/bin/duo

    wrapProgram $out/bin/duo \
      --prefix PATH : ${lib.getExe ripgrep}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/blob/main/CHANGELOG.md";
    description = "CLI for GitLab AI assistant";
    downloadPage = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp";
    homepage = "https://about.gitlab.com/gitlab-duo/";
    license = lib.licenses.mit;
    mainProgram = "duo";
    maintainers = with lib.maintainers; [ afontaine ];
  };
})
