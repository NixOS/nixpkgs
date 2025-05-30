{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-PNf7wh38FP1fFv406lo767MJyRcG+f3bTpxWaQ+Mwq4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5zSl6VaTS+C0W+QZIHbrTfIYNVl63yr7zKX+YOo9hRw=";

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
