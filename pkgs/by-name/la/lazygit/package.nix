{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazygit,
  testers,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "lazygit";
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G7JulCK9WUVWbp1V7lYuM3fehCdn1cNAJHYjr3aKDvQ=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
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
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      equirosa
      khaneliman
      starsep
      sigmasquadron
      kaynetik
    ];
    mainProgram = "lazygit";
  };
})
