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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec";
    tag = version;
    hash = "sha256-LsVK+ufSUGXWHpPk1iAFD6Lxh5hEp1WmTAy9hZMEiKk=";
  };

  vendorHash = "sha256-GzSliyKxBfATA7BaHO/4HyReEwT7dYTpRuyjADNtJuc=";

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
