{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-HwmWwGs62Dy/65HTgApuXLv4YRrFzi37A4JoL7vdLdo=";
  };

  vendorHash = "sha256-hLnoQof899zLnjbHrzvW2Y3Jj6fegxCVCRnz3XYKCeQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
      water-sucks
    ];
    mainProgram = "olm";
  };
}
