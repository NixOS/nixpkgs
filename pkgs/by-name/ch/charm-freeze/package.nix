{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "charm-freeze";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "v${version}";
    hash = "sha256-HLlMUOLDvNLVl4dvtyRwuLhp3pOlpm/naUXK2NiIAg8=";
  };

  vendorHash = "sha256-AUFzxmQOb/h0UgcprY09IVI7Auitn3JTDU/ptKicIAU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Tool to generate images of code and terminal output";
    mainProgram = "freeze";
    homepage = "https://github.com/charmbracelet/freeze";
    changelog = "https://github.com/charmbracelet/freeze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      caarlos0
      maaslalani
    ];
  };
}
