{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfox";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l342y30DFDmq2LDVr5L2ayLNUdC97zBwwL2w8C9MAek=";
  };

  vendorHash = "sha256-RnAScQlq8GCTYwhugSZC0I8Crf7CYriidICq1PEII+g=";

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
