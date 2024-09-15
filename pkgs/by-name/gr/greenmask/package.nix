{
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "greenmask";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "GreenmaskIO";
    repo = "greenmask";
    rev = "refs/tags/v${version}";
    hash = "sha256-R/JJnHBp9MPnq/fIDwYrePIUH3/FvDPFaRpmrpwhU6o=";
  };

  vendorHash = "sha256-WCsZ5DU+mZk9M1lldBY4q2PXI8DDFytPojzGJ6wqXsg=";

  subPackages = [ "cmd/greenmask/" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=${version}"
  ];

  nativeCheckInputs = [ coreutils ];

  preCheck = ''
    substituteInPlace internal/db/postgres/transformers/custom/dynamic_definition_test.go \
      --replace-fail "/bin/echo" "${coreutils}/bin/echo"

    substituteInPlace tests/integration/greenmask/main_test.go \
      --replace-fail "TestTocLibrary" "SkipTestTocLibrary" \
      --replace-fail "TestGreenmaskBackwardCompatibility" "SkipTestGreenmaskBackwardCompatibility"
    substituteInPlace tests/integration/storages/main_test.go \
      --replace-fail "TestS3Storage" "SkipTestS3Storage"
  '';

  meta = with lib; {
    description = "PostgreSQL database anonymization tool";
    homepage = "https://github.com/GreenmaskIO/greenmask";
    changelog = "https://github.com/GreenmaskIO/greenmask/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "greenmask";
  };
}
