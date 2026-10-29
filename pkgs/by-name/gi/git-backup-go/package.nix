{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  git-backup-go,
}:

buildGoModule (finalAttrs: {
  pname = "git-backup-go";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ChappIO";
    repo = "git-backup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xpHrBGgPH2dnbDz49OBntdHbowMhoz3P7k8UlNN7ku8=";
  };

  vendorHash = "sha256-xP2bV3vD4CbMGVT+MK4wJgMbIBZLvyqiMOfgj8Rc38Y=";

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

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
})
