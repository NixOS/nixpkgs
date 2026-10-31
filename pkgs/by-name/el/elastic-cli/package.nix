{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elastic-cli";
  version = "0.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWHRnvWSoJBxS9nKf+HsZdx1wiHwq/LykcCm9HxD3AQ=";
  };

  npmDepsFetcherVersion = 2;
  makeCacheWritable = true;
  dontNpmPrune = true;

  npmDepsHash = "sha256-08Y952beQwtiHO+Bmyk0Wsh+YEPErjTkdqBIvWI0XcM=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    # The workspace packages (@elastic/config-resolver, @elastic/es-schemas) are
    # symlinked into node_modules during the build. npm pack doesn't include the
    # symlink targets, so we copy the compiled workspace packages into the output
    # to satisfy the symlinks.
    cp -r packages $out/lib/node_modules/@elastic/cli/packages
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd elastic \
      --bash <($out/bin/elastic completion bash) \
      --fish <($out/bin/elastic completion fish) \
      --zsh <($out/bin/elastic completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interact with Elasticsearch, Elastic Serverless and Elastic Cloud APIs from the command line";
    homepage = "https://github.com/elastic/cli";
    changelog = "https://github.com/elastic/cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "elastic";
    platforms = lib.platforms.all;
  };
})
