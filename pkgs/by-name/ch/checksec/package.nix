{
  lib,
  fetchFromGitHub,

  buildGoModule,

  # tests
  testers,
  checksec,
}:

buildGoModule rec {
  pname = "checksec";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec";
    tag = version;
    hash = "sha256-ZpDowTmnK23+ZocOY1pJMgMSn7FiQQGvMg/gSbiL1nw=";
  };

  vendorHash = "sha256-7poHsEsRATljkqtfGxzqUbqhwSjVmiao2KoMVQ8LkD4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = checksec;
      inherit version;
    };
  };

  meta = {
    description = "Tool for checking security bits on executables";
    mainProgram = "checksec";
    homepage = "https://slimm609.github.io/checksec/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sdht0
    ];
  };
}
