{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "julius-go";
  version = "1.7.6";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "julius";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uqpm5MBlPFHzYO4OtTkv3RisHi0GLow9i7+xPb1Z/Pc=";
  };

  vendorHash = "sha256-SQCt/bxG8/ejAkosNaJ3mYIpK0bHhSUo6n5BK10upQc=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for LLM service identification";
    homepage = "https://github.com/praetorian-inc/julius";
    changelog = "https://github.com/praetorian-inc/julius/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "julius";
  };
})
