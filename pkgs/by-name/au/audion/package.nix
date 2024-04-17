{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "audion";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audion";
    rev = "refs/tags/${version}";
    hash = "sha256-j8sQCeHpxrpzyY75DypWI9z+JBWq7aaaXPnZh7ksRjc=";
  };

  cargoHash = "sha256-/x2gjLz73uPY+ouQOxLN2ViET+V/s9jgkgw97yzVj24=";

  meta = with lib; {
    description = "Ping the host continuously and write results to a file";
    homepage = "https://github.com/audiusGmbH/audion";
    changelog = "https://github.com/audiusGmbH/audion/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "audion";
  };
}
