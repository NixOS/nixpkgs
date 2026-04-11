{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  perl,
  xcbuild,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "bitwarden-cli";
  version = "2026.3.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-ecaCHk04N9h0RP8gK0o+MLgYS6Linsqi7AaC86hwQ3U=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license

    # Upstream cli-v2026.3.0 bumps @napi-rs/cli to 3.5.1 in the desktop workspace,
    # but the root lockfile still points that entry at 3.2.0.
    substituteInPlace package-lock.json \
      --replace-fail \
      $'    "apps/desktop/node_modules/@napi-rs/cli": {\n      "version": "3.2.0",\n      "resolved": "https://registry.npmjs.org/@napi-rs/cli/-/cli-3.2.0.tgz",\n      "integrity": "sha512-heyXt/9OBPv/WrTFW2+PxIMzH6MCeqP9ZsvOg0LN6pLngBnszcxFsdhCAh5I6sddzQsvru53zj59GUzvmpWk8Q==",' \
      $'    "apps/desktop/node_modules/@napi-rs/cli": {\n      "version": "3.5.1",\n      "resolved": "https://registry.npmjs.org/@napi-rs/cli/-/cli-3.5.1.tgz",\n      "integrity": "sha512-XBfLQRDcB3qhu6bazdMJsecWW55kR85l5/k0af9BIBELXQSsCFU0fzug7PX8eQp6vVdm7W/U3z6uP5WmITB2Gw==",'
  '';

  nodejs = nodejs_22;
  npmDepsFetcherVersion = 2;

  npmDepsHash = "sha256-JVRwU5MUQ8YzhCW7ODiyVqbgq7/PxgMV9dlw7i32MfI=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    perl
    xcbuild.xcrun
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  npmRebuildFlags = [
    # we'll run npm rebuild manually later
    "--ignore-scripts"
  ];

  postConfigure = ''
    # we want to build everything from source
    shopt -s globstar
    rm -r node_modules/**/prebuilds
    shopt -u globstar

    npm rebuild --verbose
  '';

  postBuild = ''
    # remove build artifacts that bloat the closure
    shopt -s globstar
    rm -r node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}
    shopt -u globstar
  '';

  postInstall = ''
    # The @bitwarden modules are actually npm workspaces inside the source tree, which
    # leave dangling symlinks behind. They can be safely removed, because their source is
    # bundled via webpack and thus not needed at run-time.
    rm -rf $out/lib/node_modules/@bitwarden/clients/node_modules/{@bitwarden,.bin}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bw --zsh <($out/bin/bw completion --shell zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    tests = {
      vaultwarden = nixosTests.vaultwarden.sqlite;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=stable"
        "--version-regex=^cli-v(.*)$"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${finalAttrs.src.tag}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      dotlambda
      caverav
    ];
  };
})
