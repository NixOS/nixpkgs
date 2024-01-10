{ lib, buildGoModule, fetchFromGitHub, asciidoctor, installShellFiles, git, testers, git-lfs }:

buildGoModule rec {
  pname = "git-lfs";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "v${version}";
    hash = "sha256-XqxkNCC2yzUTVOi/1iDsnxtLkw4jfQuBh9UsjtZ1zVc=";
  };

  vendorHash = "sha256-VmPeQYWOHFqFLHKcKH3WHz50yx7GMHVIDPzqiVwwjSg=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major version}/config.Vendor=${version}"
  ];

  subPackages = [ "." ];

  preBuild = ''
    GOARCH= go generate ./commands
  '';

  postBuild = ''
    make man
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    unset subPackages
  '';

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd git-lfs \
      --bash <($out/bin/git-lfs completion bash) \
      --fish <($out/bin/git-lfs completion fish) \
      --zsh <($out/bin/git-lfs completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = git-lfs;
  };

  meta = with lib; {
    description = "Git extension for versioning large files";
    homepage = "https://git-lfs.github.com/";
    changelog = "https://github.com/git-lfs/git-lfs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ twey marsam ];
    mainProgram = "git-lfs";
  };
}
