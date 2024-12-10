{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-2dtNQkeJXp3bub07KIpouJ2lVaTe7UECic3DIpKmQJU=";
  };

  cargoHash = "sha256-qi8twbE6ooATbzhQNvkgvXEVOQzsMqhr7BjsN+3r3tA=";

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
}
