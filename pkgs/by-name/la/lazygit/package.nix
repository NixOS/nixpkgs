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
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-hGJDsx0klccbueP7h5HtcYioFLL4gf3W3lbOHIA36FA=";
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
