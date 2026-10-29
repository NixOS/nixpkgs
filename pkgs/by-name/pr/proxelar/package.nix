{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxelar";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "emanuele-em";
    repo = "proxelar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-62CWQYHbJm27QvA5EoBJzEqetMbSjr+WlPO9rIxlzmg=";
  };

  cargoHash = "sha256-HXguxLELbrzjLAF6E04r2PnZ7M8h09x0nJFC/0V6VY8=";

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
