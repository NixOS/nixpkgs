{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "catspeak";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SchweGELBin";
    repo = "catspeak";
    tag = "v${version}";
    hash = "sha256-2NYYnhIsfE889fvbTimPVTy6dCR+i/1WaGT4Dhfuyno=";
  };

  cargoHash = "sha256-8PATds7OaD7/8FQ6XDKrCMdTcpZwi453UYq9dX/sSBk=";

  meta = with lib; {
    description = "A cowsay like program of a speaking cat, written in rust.";
    homepage = "https://github.com/SchweGELBin/catspeak";
    changelog = "https://github.com/SchweGELBin/catspeak/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SchweGELBin ];
  };
}
