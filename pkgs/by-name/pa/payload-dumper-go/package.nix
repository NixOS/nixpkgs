{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "payload-dumper-go";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ssut";
    repo = "payload-dumper-go";
    tag = finalAttrs.version;
    hash = "sha256-aCrYngtUhjNvjlPplCGwbZVRKxsuFy+xuGVnb/ShGnQ=";
  };

  vendorHash = "sha256-RVY686QB9EdPMiu3+QiJeSSVFqpvEL2tREuwKKAjoQQ=";

  buildInputs = [ xz ];

  meta = {
    description = "Android OTA payload dumper written in Go";
    homepage = "https://github.com/ssut/payload-dumper-go";
    changelog = "https://github.com/ssut/payload-dumper-go/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "payload-dumper-go";
  };
})
