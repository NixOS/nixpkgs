{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-v${finalAttrs.version}";
    hash = "sha256-XCcycFHAi3NAVGg7toCLMkVylV0kTAUb5CkLmvplR1w=";
  };

  cargoHash = "sha256-sEC20LrVHOXTf9HJPxPiWlZ94Ev8aZq57k4gMR6VTNI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  useNextest = true;
  buildAndTestSubdir = "core";

  env = {
    LIBGIT2_NO_VENDOR = true;
    OPENSSL_NO_VENDOR = true;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The monolithic Norg static site generator built with Rust";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "lith";
  };
})
