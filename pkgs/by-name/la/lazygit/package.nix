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
<<<<<<< HEAD
  version = "0.57.0";
=======
  version = "0.56.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DC0wVkFI7Te3QSE8Y0WU/ysanfukTkGa3N43hmKHXW8=";
=======
    hash = "sha256-oTj+9zDmbXD4rlFZ++hcd1WSfskSNI7ojI9gN8UcpT8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      equirosa
      khaneliman
      starsep
      sigmasquadron
    ];
    mainProgram = "lazygit";
  };
}
