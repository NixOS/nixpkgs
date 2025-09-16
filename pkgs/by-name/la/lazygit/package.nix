{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazygit,
  testers,
  nix-update-script,
}:
buildGoModule rec {
  pname = "lazygit";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${version}";
    hash = "sha256-gx9l7MHWQGnLsD+L+SM+KzBgU8RLtpZG+66pPyerZW4=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.buildSource=nix"
  ];

  passthru = {
    tests.version = testers.testVersion { package = lazygit; };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      equirosa
      khaneliman
      starsep
      sigmasquadron
    ];
    mainProgram = "lazygit";
  };
}
