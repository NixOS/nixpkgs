{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grimoire";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "grimoire";
    tag = "v${version}";
    hash = "sha256-V6j6PBoZqTvGfYSbpxd0vOyTb/i2EV8pDVSuZeq1s5o=";
  };

  vendorHash = "sha256-K1kVXSfIjBpuJ7TyTCtaWj6jWRXPQdBvUlf5LC60tj0=";

  subPackages = [ "cmd/grimoire/" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to generate datasets of cloud audit logs for common attacks";
    homepage = "https://github.com/DataDog/grimoire";
    changelog = "https://github.com/DataDog/grimoire/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "grimoire";
  };
}
