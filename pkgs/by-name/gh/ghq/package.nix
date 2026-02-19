{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  ghq,
}:

buildGoModule (finalAttrs: {
  pname = "ghq";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Iw8hu2QtnRgRbSTqtIPDmKbx5FcE2j68VfzP4egbZgY=";
  };

  vendorHash = "sha256-RRxRwYTkveOZvvxAwpG9ie4+ZdUDDkZZfX5cNn0DAhA=";

  doCheck = false;

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
