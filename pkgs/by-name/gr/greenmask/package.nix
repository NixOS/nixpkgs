{
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "greenmask";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "GreenmaskIO";
    repo = "greenmask";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/At0boolTyge4VNy1EDpK09Yo7hLAdq6SvCbyBTKGbw=";
  };

  vendorHash = "sha256-t2U65GAGBGdMRXPTkCQCuXfLuqohA6erTlvAN/xx/ek=";

  subPackages = [ "cmd/greenmask/" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/GreenmaskIO/greenmask/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "greenmask";
  };
})
