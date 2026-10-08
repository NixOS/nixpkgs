{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith-plugin-sdk";
  version = "1.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-plugin-sdk-v${finalAttrs.version}";
    hash = "sha256-jL8Ajv3K70t1eXttqtrm9WoN9QRW6aucK380iJn3ACw=";
  };

  cargoHash = "sha256-KhsNCVZAFDWVlxTzkpTdDT6RqE9j+nejTj0botqywvM=";

  cargoRoot = "sdk";
  buildAndTestSubdir = "sdk";

  meta = {
    description = "SDK for building Norgolith plugins";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/norgolith-plugin-sdk-v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "norgolith-plugin-sdk";
  };
})
