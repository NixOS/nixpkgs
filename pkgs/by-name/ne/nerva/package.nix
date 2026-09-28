{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "nerva";
  version = "1.70.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "nerva";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKGcn1F2uF5vUVVL8oBDmBG5434bLXzCyyFL95Y3t/Y=";
  };

  vendorHash = "sha256-Fjxs+JKq9Lv9wBQEjvSlEw9cpgm/Ye1l4iqdjRa8+X8=";

  ldflags = [
    "-s"
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
