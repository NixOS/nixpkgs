{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, git
, pandoc
}:

buildGoModule rec {
  pname = "gg-scm";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gg-scm";
    repo = "gg";
    rev = "v${version}";
    sha256 = "sha256-kLmu4h/EBbSFHrffvusKq38X3/ID9bOlLMvEUtnFGhk=";
  };
  patches = [ ./skip-broken-revert-tests.patch ];
  subPackages = [ "cmd/gg" ];
  ldflags = [
    "-s" "-w"
    "-X" "main.versionInfo=${version}"
    "-X" "main.buildCommit=a0b348c9cef33fa46899f5e55e3316f382a09f6a+"
  ];

  vendorSha256 = "sha256-+ZmNXB+I6vPRbACwEkfl/vVmqoZy67Zn9SBrham5zRk=";

  nativeBuildInputs = [ git pandoc installShellFiles makeWrapper ];
  buildInputs = [ git ];

  postInstall = ''
    wrapProgram $out/bin/gg --suffix PATH : ${git}/bin
    pandoc --standalone --to man misc/gg.1.md -o misc/gg.1
    installManPage misc/gg.1
    installShellCompletion --cmd gg \
      --bash misc/gg.bash \
      --zsh misc/_gg.zsh
  '';

  meta = with lib; {
    mainProgram = "gg";
    description = "Git with less typing";
    longDescription = ''
      gg is an alternative command-line interface for Git heavily inspired by Mercurial.
      It's designed for less typing in common workflows,
      making Git easier to use for both novices and advanced users alike.
    '';
    homepage = "https://gg-scm.io/";
    changelog = "https://github.com/gg-scm/gg/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ zombiezen ];
  };
}
