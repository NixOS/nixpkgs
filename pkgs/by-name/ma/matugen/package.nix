{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${version}";
    hash = "sha256-TD9XyqFdLIOLRZM7ozQ8gz4PyEQbLGLxB4MbzjLccg4=";
  };

  cargoHash = "sha256-OdJxr01wHqPHgEGIVrLcUv5h1JaYrY1zW9NrYO114OM=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}
