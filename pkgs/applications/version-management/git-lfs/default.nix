{ lib, buildGoModule, fetchFromGitHub, ronn, installShellFiles, git, testers, git-lfs }:

buildGoModule rec {
  pname = "git-lfs";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "v${version}";
    sha256 = "sha256-3gVUPfZs5GViEA3D7Zm5NdxhuEz9DhwPLoQqHFdGCrI=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ ronn installShellFiles ];

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

  checkInputs = [ git ];

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
