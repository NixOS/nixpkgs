{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  ghq,
}:

buildGo126Module (finalAttrs: {
  pname = "ghq";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-z7tLCSThR4EFLk8GnyrB8H6d/9t5AKegVEdzlleCS94=";
  };

  vendorHash = "sha256-/uk1hf5eXpNULKm7UeVgQ7Lc7YOU+eV9Yd/4lYorz/8=";

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
