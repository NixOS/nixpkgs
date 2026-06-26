{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "aviator";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "herrjulz";
    repo = "aviator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jqAGwPqxxCkBpSMebikdUGh54hlSLeqAyf7BOBtjiNA=";
  };

  patches = [
    # Fix test failures caused by type mismatch in ForEach.Except field
    # The Except field was changed from string to []string
    ./fix-except-type.patch
  ];

  deleteVendor = true;
  vendorHash = "sha256-rYOphvI1ZE8X5UExfgxHnWBn697SDkNnmxeY7ihIZ1s=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Merge YAML/JSON files in a in a convenient fashion";
    homepage = "https://github.com/herrjulz/aviator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
    mainProgram = "aviator";
  };
})
