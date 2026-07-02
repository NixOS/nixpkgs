{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxelar";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "emanuele-em";
    repo = "proxelar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mr7jdUK/5XMhcu6DgJHUKkdGbqNptf83I3663y/MhMo=";
  };

  cargoHash = "sha256-8iCB6Vs3W6HcAjyL29WfciXT/OU56moPX13RYzGSLl0=";

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
