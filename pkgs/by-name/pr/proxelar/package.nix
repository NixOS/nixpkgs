{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxelar";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "emanuele-em";
    repo = "proxelar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQRGn03chv+x3AO0yyxkXDmrCHVDP9vjaVUwMRMxpYE=";
  };

  cargoHash = "sha256-1cPkzDIF4bcESbEOATYM2fd7FenV5dkrrYsZIoCML7Q=";

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Programmable MITM proxy that intercepts HTTP/HTTPS traffic";
    homepage = "https://github.com/emanuele-em/proxelar";
    changelog = "https://github.com/emanuele-em/proxelar/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "proxelar";
  };
})
