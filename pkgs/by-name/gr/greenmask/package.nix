{
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "greenmask";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "GreenmaskIO";
    repo = "greenmask";
    tag = "v${version}";
    hash = "sha256-KHM/r4zDJrZMIC7+Kp+98xhV5r4zkpxc1ffqf0jgnLs=";
  };

  vendorHash = "sha256-g3/WuLDb4mAzklT+nxQ1U/l+JDzSubENMB5hWjIaIIU=";

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

  meta = {
    description = "PostgreSQL database anonymization tool";
    homepage = "https://github.com/GreenmaskIO/greenmask";
    changelog = "https://github.com/GreenmaskIO/greenmask/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "greenmask";
  };
}
