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
  version = "8.57.1";

  # DOCS https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp#node-version
  nodejs = nodejs_22;

  src = fetchFromGitLab {
    group = "gitlab-org";
    owner = "editor-extensions";
    repo = "gitlab-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IofCSh9ja3C8WEiksp0pFJ6LZOu86o4VHnwiIUHHgLI=";
  };

  patches = [
    # HACK https://github.com/NixOS/nixpkgs/issues/408720
    # Fix packages locked but without hash, or even missing
    ./missing-hashes.patch
  ];

  # PATCH: Only build for the current platform, not all targets
  postPatch = ''
    substituteInPlace packages/cli/scripts/compile_executables.sh \
      --replace-fail \
        'SUPPORTED_TARGETS="bun-linux-x64 bun-linux-arm64 bun-windows-x64 bun-darwin-arm64 bun-darwin-x64"' \
        "SUPPORTED_TARGETS=bun-$TARGET"
  '';

  npmFlags = [ "--install-links" ];
  npmDepsHash = "sha256-dj4TrKMdXgUZr7/0NLT7h8jT3VjobB9KFO8tl/+47rk=";
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
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/blob/main/CHANGELOG.md";
    description = "CLI for GitLab AI assistant";
    downloadPage = "https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp";
    homepage = "https://about.gitlab.com/gitlab-duo/";
    license = lib.licenses.mit;
    mainProgram = "duo";
    maintainers = with lib.maintainers; [ yajo ];
  };
})
