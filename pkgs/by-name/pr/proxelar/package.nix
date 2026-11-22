{
  lib,
  aws-lc,
  clang,
  cmake,
  fetchFromGitHub,
  gitMinimal,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxelar";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emanuele-em";
    repo = "proxelar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1XF5eoAGl5B6sX1j7nZs8vkfm+6vpn2ACOG/0scPkr0=";
  };

  cargoHash = "sha256-KMEHI+ZchY9C1PF/AqBVbyUu2QkKf8QgJQ/g/RioSxA=";

  nativeBuildInputs = [
    clang
    cmake
    gitMinimal
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    openssl
    zstd
  ];

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
