{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazygit,
  testers,
}:
buildGoModule rec {
  pname = "lazygit";
  version = "0.47.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-b3mloUFB/ATIkjwkqFzCYdLiDyQXkGnLaZrGc79tkf8=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.buildSource=nix"
  ];

  passthru.tests.version = testers.testVersion { package = lazygit; };

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
