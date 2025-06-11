{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-ilqIqw0N4Xsfw7ntLxoz4Ogn2e3NH8VnqAgowbvfZ+0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-acWEinwYCCtoapFkL6XyASvFX4bqYS/HrKjlaAZabi4=";

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
}
