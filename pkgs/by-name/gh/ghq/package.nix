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
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-SmcgBwd5k/lAv9bwYRpkIM0fil2ajSlT8zznP7bgpDk=";
  };

  vendorHash = "sha256-8aC1J/mM7ZTEQBdZwstvHxMKDPqgzjzYztC7shuwu/Q=";

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
