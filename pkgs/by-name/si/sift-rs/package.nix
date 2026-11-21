{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sift-rs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rupurt";
    repo = "sift";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1ngTLt5whz5NT2aklwPnx7PaR9iUfq8niHtMWUXbnSU=";
  };

  cargoHash = "sha256-/1HbCyTl6uEmzxEqLxzQKyC6zqIx7RkPbewbKBwXTqw=";

  doCheck = false;

  meta = {
    description = "Standalone Rust CLI for local document retrieval in agentic coding workflows";
    homepage = "https://github.com/rupurt/sift";
    license = lib.licenses.mit;
    mainProgram = "sift";
    maintainers = with lib.maintainers; [ rupurt ];
  };
})
