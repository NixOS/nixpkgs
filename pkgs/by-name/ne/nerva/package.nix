{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nerva";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "nerva";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kiVZFByiNCyubtzDryVwi6x/Xo1StEtlnOTlD9MfwP0=";
  };

  vendorHash = "sha256-Z0MSD+1/1VzrJ+pz5x0JvxrCxtJe59ckaTqHK/+TVN8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  # Tests require a docker setup
  doCheck = false;

  meta = {
    description = "Fingerprinting CLI tool for various protocols";
    homepage = "https://github.com/praetorian-inc/nerva";
    changelog = "https://github.com/praetorian-inc/nerva/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nerva";
  };
})
