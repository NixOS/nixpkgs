{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "1.14.15";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D1B5j1HYSXDgr1vW8kHzCohu3HiDljTEhQhzfa5q/Us=";
  };

  vendorHash = "sha256-/0kNURJHIRS1thqEe8d+SAsm8NPOEJa//g9tyswrvFg=";

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
