{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "charm-freeze";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    tag = "v${version}";
    hash = "sha256-1zc62m1uS8Bl6x54SG2///PWfiKbZood6VBibbsFX7I=";
  };

  vendorHash = "sha256-BEMVjPexJ3Y4ScXURu7lbbmrrehc6B09kfr03b/SPg8=";

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
