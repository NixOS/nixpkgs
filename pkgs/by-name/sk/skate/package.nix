{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "skate";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BswVm5YH8TR0svPFWsIiNHLIQGqdXfysjy0KwZZ6Io8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-kIENDHcO/aLEfzJv1dCDSb0NmZf0/khIn0qqlxiFS1c=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    changelog = "https://github.com/charmbracelet/skate/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "skate";
  };
})
