{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gip";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "gip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UgvXaDNdH8ZN00oJ/DjIlBs86ua3JmVz1JfLk2XBVFw=";
  };

  cargoHash = "sha256-C38pV8c7znbBua130qDaguUAWamGhxfI8y0Vy0yadWc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  __structuredAttrs = true;

  # Tests that require network access
  doCheck = false;

  meta = {
    description = "Command-line tool to get global IP address";
    homepage = "https://github.com/dalance/gip";
    changelog = "https://github.com/dalance/gip/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gip";
  };
})
