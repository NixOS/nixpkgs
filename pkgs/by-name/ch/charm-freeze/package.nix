{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "charm-freeze";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "v${version}";
    hash = "sha256-eV8X/vftF/GGuM0RnLCkIStSR98fN6nmW3BzoASPLH0=";
  };

  vendorHash = "sha256-Y/UsqYtzXtOCE4bGf/mRAqJ0GxEtKq0qYecbitn0EhM=";

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
