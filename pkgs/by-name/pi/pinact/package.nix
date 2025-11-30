{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

let
  mainProgram = "pinact";
in
buildGoModule (finalAttrs: {
  pname = "pinact";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YupEKk8s8NMKcj3TjKYt1/bPpHEA1UGSjbeX4wd+f7U=";
  };

  vendorHash = "sha256-00ohijhFWTKYpzApSeMXNsE1xigz9MgMR5fvMUDUGNs=";

  env.CGO_ENABLED = 0;

  doCheck = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd '${mainProgram}' \
      --bash <("$out/bin/${mainProgram}" completion bash) \
      --zsh <("$out/bin/${mainProgram}" completion zsh) \
      --fish <("$out/bin/${mainProgram}" completion fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";
  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([\\d\\.]+)$"
      ];
    };
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version} -X main.commit=v${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/pinact"
  ];

  meta = {
    inherit mainProgram;
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kachick ];
  };
})
