{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-FR+XHgL/DfVFeEbAT1h1nwBnJkG7jnHfd+JRLVTY0LE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qRqdNCeVb7dD91q6gEK1c5rQ8LhcwJ5hwn1TfSPseO4=";

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
}
