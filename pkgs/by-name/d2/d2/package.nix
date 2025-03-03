{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  installShellFiles,
  git,
  testers,
  d2,
}:

buildGo123Module rec {
  pname = "d2";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Z+RC3wXqplGxaECIpHDiV8giWItvE5KFh3N+mwVL6HU=";
  };

  vendorHash = "sha256-ujyPfQx9FyMq5GBRquBHxcQ47R72RP6g2/rqLICDdWM=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    # See https://github.com/terrastruct/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
    export TESTDATA_ACCEPT=1
  '';

  passthru.tests.version = testers.testVersion {
    package = d2;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Modern diagram scripting language that turns text to diagrams";
    mainProgram = "d2";
    homepage = "https://d2lang.com";
    changelog = "https://github.com/terrastruct/d2/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
  };
}
