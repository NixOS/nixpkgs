{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nerva";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "nerva";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EZQQLXN9eixL3BUSn6VAaKPe9uA3uW1l6zfzq3bG+vk=";
  };

  vendorHash = "sha256-h3pxl84P7dUmXJJ9t/Rnzx0oJcGnA+7ytGWhk401ecY=";

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
