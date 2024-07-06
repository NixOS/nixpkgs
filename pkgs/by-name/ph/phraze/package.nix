{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "phraze";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${version}";
    hash = "sha256-lW7oYivIDGYg78MgcLFFNyxciVk+wKU/OBzWYx3KwPI=";
  };

  doCheck = true;

  cargoHash = "sha256-kFk04YKDYiABWtild6aaP9H8gt/TuckOWRJE69dAXGU=";

  meta = {
    description = "Generate random passphrases";
    homepage = "https://github.com/sts10/phraze";
    changelog = "https://github.com/sts10/phraze/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "phraze";
  };
}
