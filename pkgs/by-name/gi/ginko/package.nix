{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ginko";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "Schottkyc137";
    repo = "ginko";
    tag = "v${version}";
    hash = "sha256-lk+iZclni6jAkvN5/62YobFBAdwTUOfd5v7Fs8M6MQo=";
  };

  cargoHash = "sha256-7VwvFDjwUZechUrkxnXPFN6aMkr9KJkV81rpOZJHr8E=";

  meta = {
    description = "Device-tree source parser, analyzer and language server";
    maintainers = [ lib.maintainers.fredeb ];
    license = lib.licenses.mit;
    homepage = "https://github.com/Schottkyc137/ginko";
    changelog = "https://github.com/Schottkyc137/ginko/releases/tag/v${version}/CHANGELOG.md";
  };
}
