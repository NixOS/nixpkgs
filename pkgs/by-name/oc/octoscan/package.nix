{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "octoscan";
  version = "0-unstable-2024-08-25";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    # https://github.com/synacktiv/octoscan/issues/7
    rev = "69f0761fe4d31f7fe4050fde5fd807364155fde4";
    hash = "sha256-2aCjqjBDXqGbu94o22JRpJ5nUv8U46JGRcrBJCINflQ=";
  };

  vendorHash = "sha256-9IT8qTFzn8otWGTBP7ODcT8iBckIJ/3+jkbF1dq6aDw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Static vulnerability scanner for GitHub action workflows";
    homepage = "https://github.com/synacktiv/octoscan";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octoscan";
  };
}
