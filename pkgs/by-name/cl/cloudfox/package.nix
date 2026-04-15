{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfox";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vP19+COji92pm0a08PCE6KNaXgOWajavSuwhlaaPhl0=";
  };

  vendorHash = "sha256-cQxmDyr+K0Gvv4QdWs9A/Ju7X53+zHQ+OXKI+SySUik=";

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
