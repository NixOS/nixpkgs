{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith-plugin-sdk";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-plugin-sdk-v${finalAttrs.version}";
    hash = "sha256-XCcycFHAi3NAVGg7toCLMkVylV0kTAUb5CkLmvplR1w=";
  };

  cargoHash = "sha256-zNch2yFswY9L9cYckYB7P5lV82XYbFY7Zct9Bw6hjd8=";

  cargoRoot = "sdk";
  buildAndTestSubdir = "sdk";

  meta = {
    description = "SDK for building Norgolith plugins";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "norgolith-plugin-sdk";
  };
})
