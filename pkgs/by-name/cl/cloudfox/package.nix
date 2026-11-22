{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfox";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KuS7uQCSY/3FuLwvBlZY+tjYuDdNd+OkwKpQLyv8U5I=";
  };

  vendorHash = "sha256-RO/Xn8gDqCWVfI0yFuqHBj4rYh/fIMAJ80kKFj1ZFwI=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudfox";
  };
})
