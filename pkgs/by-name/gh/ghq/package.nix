{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  testers,
  nix-update-script,
  writableTmpDirAsHomeHook,
  ghq,
}:

buildGoModule (finalAttrs: {
  pname = "ghq";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-UrxfWZw9TBQUuTfhp2IVfVxnFvGF1GIRfP87mkND/1Q=";
  };

  vendorHash = "sha256-FvMqeUfX4c2Vm+L2GIDGoxN3w+7UyNI0VRada0zSvcc=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-X=main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --bash $src/misc/bash/_ghq \
      --fish $src/misc/fish/ghq.fish \
      --zsh $src/misc/zsh/_ghq
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ghq;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote repository management made easy";
    homepage = "https://github.com/x-motemen/ghq";
    maintainers = with lib.maintainers; [ sigma ];
    license = lib.licenses.mit;
    mainProgram = "ghq";
  };
})
