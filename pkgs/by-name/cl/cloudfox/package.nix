{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfox";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IyuR8NA4y1psBRseLPFiXtXZ7zkKhOxxI+QjeitDaIE=";
  };

  vendorHash = "sha256-oohACm7oQhRYF6XzYLku20yIKH9DamAL+S8gXrvF/RY=";

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
