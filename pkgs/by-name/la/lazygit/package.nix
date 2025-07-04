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
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${version}";
    hash = "sha256-tbFRovaB0f+0VyX34DEXvWYjV3fipc5kbRNhm7rVMlo=";
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
      paveloom
      starsep
      sigmasquadron
    ];
    mainProgram = "lazygit";
  };
}
