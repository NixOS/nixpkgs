{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qcy9CkoXBXUYxrySxpRcTnHaHO7KhJK9WsptKn7lKz0=";
  };

  vendorHash = "sha256-M7eyEoE9FAGZvHvIwrvVYyDCcyYxnn7bWBTOBDRl7aU=";

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  meta = {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
})
