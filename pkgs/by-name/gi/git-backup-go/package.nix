{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  git-backup-go,
}:

buildGoModule rec {
  pname = "git-backup-go";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ChappIO";
    repo = "git-backup";
    rev = "v${version}";
    hash = "sha256-C/ha/GuRvqxmgrbOgkhup1tNoDT3pDIbE+nO5eMZGlY=";
  };

  vendorHash = "sha256-wzivnTe9Rx3YLz6lvrzsLiJIbxX7QE059Kzb4rUfD+s=";

  ldflags = [ "-X main.Version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = git-backup-go;
    command = "git-backup -version";
  };

  meta = {
    description = "Backup all your GitHub & GitLab repositories";
    homepage = "https://github.com/ChappIO/git-backup";
    license = lib.licenses.asl20;
    mainProgram = "git-backup";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
