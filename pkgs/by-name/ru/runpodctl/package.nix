{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-09EOqntCGEuOKiWceiT1gfAQ4du0zMoFg20KrmQLgZ4=";
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
