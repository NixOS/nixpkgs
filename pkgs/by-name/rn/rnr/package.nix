{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rnr";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ismaelgv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g/PnvOZzlWzEHf3vvYANeJ2ogQ/6duNzhlKpKMBoBFU=";
  };

  cargoHash = "sha256-+oDRNBQ03MknhcTpZFKt0ipJY43LPOKbGF014rrs6dw=";

  meta = with lib; {
    description = "Command-line tool to batch rename files and directories";
    mainProgram = "rnr";
    homepage = "https://github.com/ismaelgv/rnr";
    changelog = "https://github.com/ismaelgv/rnr/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
