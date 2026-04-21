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
}:
buildNpmPackage (finalAttrs: {
  pname = "gitlab-duo";
  version = "8.67.0";

  # DOCS https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp#node-version
  nodejs = nodejs_22;

  src = fetchFromGitLab {
    group = "gitlab-org";
    owner = "editor-extensions";
    repo = "gitlab-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnL3720MwiWtC7lHA4CrfiZUTeOV+ytWFii16OKGbAM=";
  };

  patches = [
    # HACK https://github.com/NixOS/nixpkgs/issues/408720
    # Fix packages locked but without hash, or even missing
    ./missing-hashes.patch
  ];

  # PATCH:
  # 1. Only build for the current platform, not all targets.
  # 2. Compile from pre-bundled dist instead of raw source, to work around a Bun
  #    bundler issue where re-bundling produces code in turn cannot be parsed:
  #
  #        SyntaxError: Cannot declare a function that shadows a let/const/class/function variable '_init'.
  #              at <parse> (/$bunfs/root/duo-darwin-arm64:323006:1)
  #              at native:11:43
  postPatch = ''
    sed -i \
      -e 's/SUPPORTED_TARGETS=".\+"/SUPPORTED_TARGETS="bun-$TARGET"/' \
      -e 's|SOURCE_FILE="./src/index.tsx"|SOURCE_FILE="./dist/index.js"|' \
      packages/cli/scripts/compile_executables.sh
  '';

  npmFlags = [ "--install-links" ];
  npmDepsHash = "sha256-9b73NGu3GO5Sgus7BZ7WvOaXBvQ3UrW9BUTk6NwH+uY=";
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

  postConfigure = ''
    patchShebangs --build ./packages/cli/scripts
    npmBuildScript=build:bundle runHook npmBuildHook
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 packages/cli/bin/duo-$TARGET $out/bin/duo

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
