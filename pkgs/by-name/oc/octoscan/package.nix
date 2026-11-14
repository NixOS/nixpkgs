{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "octoscan";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wdxuFYdM/0oEPQzr4EZ8fqNGo5CZrpz014kaVQXB3Bs=";
  };

  vendorHash = "sha256-+TQDZXqWNBFAPES0qsrpBdl/jQZAfHXBcav2HcS0d7o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Static vulnerability scanner for GitHub action workflows";
    homepage = "https://github.com/synacktiv/octoscan";
    changelog = "https://github.com/synacktiv/octoscan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octoscan";
  };
})
