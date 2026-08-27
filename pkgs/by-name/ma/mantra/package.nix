{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mantra";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "brosck";
    repo = "Mantra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DnErXuMbCRK3WxhdyPj0dOUtGnCcmynPk/hYmOsOKVU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool used to hunt down API key leaks in JS files and pages";
    homepage = "https://github.com/brosck/mantra";
    changelog = "https://github.com/brosck/mantra/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mantra";
  };
})
