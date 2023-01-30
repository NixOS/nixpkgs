{ lib, buildGoModule, fetchFromGitHub, asciidoctor, installShellFiles, git, testers, git-lfs }:

buildGoModule rec {
  pname = "git-lfs";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "v${version}";
    hash = "sha256-r1z97sgqo1IyR0oW5b3bMGTUHGE8U+hrWgQ0Su9FRrw=";
  };

  vendorHash = "sha256-did6qAUawmQ/juLzJWIXGzmErj9tBKgM7HROTezX+tw=";

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
  };
}
