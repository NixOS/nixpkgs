{
  lib,
  buildGoModule,
  fetchFromGitHub,
  osv-detector,
  testers,
}:

buildGoModule rec {
  pname = "osv-detector";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = "osv-detector";
    rev = "v${version}";
    hash = "sha256-vIkLrKyDeMfRe/0EPhlKlHAO6XB0/OFY5mTUHeZbcg8=";
  };

  vendorHash = "sha256-Rrosye8foVntoFDvDmyNuXgnEgjzcOXenOKBMZVCRio=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable tests requiring network access
        "TestRun_ParseAs_CsvFile"
        "TestRun_ParseAs_CsvRow"
        "TestRun_DBs"
        "TestRun_Lockfile"
        "TestRun_ParseAsGlobal"
        "TestRun_Ignores"
        "TestRun_ParseAsSpecific"
        "TestRun_Configs"
      ];
    in
    [
      "-skip"
      "${builtins.concatStringsSep "|" skippedTests}"
    ];

  passthru.tests.version = testers.testVersion {
    package = osv-detector;
    command = "osv-detector -version";
    version = "osv-detector ${version} (unknown, commit none)";
  };

  meta = {
    description = "Auditing tool for detecting vulnerabilities";
    mainProgram = "osv-detector";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
