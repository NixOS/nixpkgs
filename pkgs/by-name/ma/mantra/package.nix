{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mantra";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "MrEmpy";
    repo = "Mantra";
    tag = "v${version}";
    hash = "sha256-fBcoKoTBGCyJS8+mzKXLGxcxmRsCcZFZEyMTnA5Rkbw=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool used to hunt down API key leaks in JS files and pages";
    homepage = "https://github.com/MrEmpy/Mantra";
    changelog = "https://github.com/MrEmpy/Mantra/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mantra";
  };
}
