{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  coreutils,
}:

buildGoModule (finalAttrs: {
  pname = "bootdev-cli";
  version = "1.32.1";

  src = fetchFromGitHub {
    owner = "bootdotdev";
    repo = "bootdev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DScpeUQdkzJy+RVkA8ZmGzp5Z9YzkvZViCoov64WAJk=";
  };

  vendorHash = "sha256-ZDioEU5uPCkd+kC83cLlpgzyOsnpj2S7N+lQgsQb8uY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  # TestGetLatestVersionHasOverallTimeout writes a fake go helper that runs
  # /bin/sleep; that path is missing in the Nix sandbox, and the test also
  # resets PATH so a bare "sleep" would not help. Point at store sleep.
  postPatch = ''
    substituteInPlace version/version_test.go \
      --replace-fail 'exec /bin/sleep 5' 'exec ${lib.getExe' coreutils "sleep"} 5'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd bootdev --"$shell" <($out/bin/bootdev completion "$shell")
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/bootdev";
  doInstallCheck = true;

  # checks tests use httptest.NewServer (bind localhost)
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI used to complete coding challenges and lessons on Boot.dev";
    homepage = "https://github.com/bootdotdev/bootdev";
    changelog = "https://github.com/bootdotdev/bootdev/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "bootdev";
  };
})
