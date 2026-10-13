{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rita";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "activecm";
    repo = "rita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-By0JvQ4LTm+NEnRMadE1x2PiiYqnJQCsF3Fy+gHulXs=";
  };

  vendorHash = "sha256-KyC7VPgWlgKD6KWWRo3hFQHl2HjTub+VSMtJCpYE6Zk=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/activecm/rita/config.Version=${finalAttrs.version}"
    "-X=github.com/activecm/rita/config.ExactVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "Framework for detecting command and control communication through network traffic analysis";
    homepage = "https://github.com/activecm/rita";
    changelog = "https://github.com/activecm/rita/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rita";
  };
})
