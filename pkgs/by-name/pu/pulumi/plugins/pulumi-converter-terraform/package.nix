{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-converter-terraform";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-converter-terraform";
    tag = "v${version}";
    hash = "sha256-pqV5fIyiAm3TyyOs0LzxdeI6WEzqBsrtU4gQ2MCSRW8=";
  };

  vendorHash = "sha256-dCsb6qbbPXC3a+1iJ/RFykHlOpbpxZNxJtDE5VKWEzI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-converter-terraform/pkg/version.Version=${version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestTranslate"
        "TestTranslateParameterized"
      ]
    }$"
  ];

  excludedPackages = [
    "pkg/internal/shim"
    "tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/pulumi/pulumi-converter-terraform";
    description = "Convert Terraform projects to Pulumi programs written in your favourite languages";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-converter-terraform";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
