{ lib, buildGoModule, fetchFromGitHub, asciidoctor, installShellFiles, git, testers, git-lfs }:

buildGoModule rec {
  pname = "git-lfs";
  # Inclues git compatibility fixes which are in master, but no official release
  version = "unstable-2023-01-10";
  # This is the commit hash on the upstream repo, used for vendoring
  upstreamVersion = "cd04b35";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "cd04b3598344a57d22cd5e6ce2658a719de848e3";
    hash = "sha256-JHfTge+vmjNKkbBeICaJ9srGSNdPIV8fPS9Xs8WSDMs=";
  };

  vendorHash = "sha256-N8HB2qwBxjzfNucftHxmX2W9srCx62pjmkCWzwiCj/I=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major upstreamVersion}/config.Vendor=${upstreamVersion}"
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
