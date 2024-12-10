{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "sanctity";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-y6xj4A5SHcW747aFE9TfuurNnuUxjTUeKJmzxeiWqVc=";
  };

  cargoHash = "sha256-co58YBeFjP9DKzxDegQI7txuJ1smqJxdlRLae+Ppwh0=";

  meta = with lib; {
    description = "Test the 16 terminal colors in all combinations";
    homepage = "https://codeberg.org/annaaurora/sanctity";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "sanctity";
  };
}
