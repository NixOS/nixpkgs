{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  git-backup-go,
}:

buildGoModule rec {
  pname = "git-backup-go";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "ChappIO";
    repo = "git-backup";
    rev = "v${version}";
    hash = "sha256-Z32ThzmGkF89wsYqJnP/Koz4/2mulkrvvnUKHE6Crks=";
  };

  vendorHash = "sha256-BLnnwwCrJJd8ihpgfdWel7l8aAIVVJBIpE+97J9ojPo=";

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
