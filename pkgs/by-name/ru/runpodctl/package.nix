{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "3.1.0";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qcy9CkoXBXUYxrySxpRcTnHaHO7KhJK9WsptKn7lKz0=";
  };

  vendorHash = "sha256-M7eyEoE9FAGZvHvIwrvVYyDCcyYxnn7bWBTOBDRl7aU=";

  ldflags = [
    "-s"
  ];

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
})
