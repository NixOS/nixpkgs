{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "skate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    hash = "sha256-HwtBY4rtqyY+DMNq2Fu30/CsTlhhGOuJRrdM5zHUAIg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-nCT9PsRPxefjC4q4cr5UigTITUkx0JmQtdv7/ZXbXVI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    changelog = "https://github.com/charmbracelet/skate/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      penguwin
    ];
    mainProgram = "skate";
  };
}
