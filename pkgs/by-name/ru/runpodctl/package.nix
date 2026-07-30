{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QorGhaHwgzcJJXa36dejLdN8STa8Q7H8qvKK66g2JBA=";
  };

  vendorHash = "sha256-38d+nWZDjWgcK091G3JCGtBqyE7iJ60edAhbx8GzxPM=";

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
