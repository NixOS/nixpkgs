{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xz,
}:

buildGoModule rec {
  pname = "payload-dumper-go";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ssut";
    repo = "payload-dumper-go";
    tag = version;
    hash = "sha256-TFnBWylOoyleuBx3yYfHl1kWO6jVBiqsi8AMYLMuuk0=";
  };

  vendorHash = "sha256-XeD47PsFjDT9777SNE8f2LbKZ1cnL5HNPr3Eg7UIpJ0=";

  buildInputs = [ xz ];

  meta = {
    description = "Android OTA payload dumper written in Go";
    homepage = "https://github.com/ssut/payload-dumper-go";
    changelog = "https://github.com/ssut/payload-dumper-go/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "payload-dumper-go";
  };
}
