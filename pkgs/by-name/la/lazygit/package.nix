{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  lazygit,
  testers,
}:
# Regression in go1.23 see https://github.com/jesseduffield/lazygit/issues/4002
buildGo122Module rec {
  pname = "lazygit";
  version = "0.45.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-B8z0NqCFdCAYVZnujfDJ9Y4qFXuhy5A/RG51Qb2J4ts=";
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
