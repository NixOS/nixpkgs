{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazygit,
  testers,
}:
buildGoModule rec {
  pname = "lazygit";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-L3OcCkoSJZ6skzcjP2E3BrQ39cXyxcuHGthj8RHIGeQ=";
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
