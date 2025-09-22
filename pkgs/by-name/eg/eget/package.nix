{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pandoc,
  installShellFiles,
  nix-update-script,
  testers,
  eget,
}:

buildGoModule rec {
  pname = "eget";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "eget";
    rev = "v${version}";
    sha256 = "sha256-jhVUYyp6t5LleVotQQme07IJVdVnIOVFFtKEmzt8e2k=";
  };

  vendorHash = "sha256-A3lZtV0pXh4KxINl413xGbw2Pz7OzvIQiFSRubH428c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  postInstall = ''
    pandoc man/eget.md -s -t man -o eget.1
    installManPage eget.1
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = eget;
      command = "eget -v";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Easily install prebuilt binaries from GitHub";
    homepage = "https://github.com/zyedidia/eget";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
