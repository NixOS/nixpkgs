{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "metabigor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "metabigor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sFrcre4S2VTmKFzBLCkFXLr+HW/WZ0XhMEFl7N1WgOA=";
  };

  vendorHash = "sha256-GN069be+ZUXBA0d8Mq4ffgTM8JHlDhlVZCw2AyAxVHw=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    changelog = "https://github.com/j3ssie/metabigor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "metabigor";
  };
})
