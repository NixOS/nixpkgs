{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-motd";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = "rust-motd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xZwp4bCG9BMqFmLa89fh/wAkM42Vx3+vNq+AnnDa620=";
  };

  cargoHash = "sha256-cwsszuIeQp5HIHqUYh70/7kNAYZG+xJxHB87Hzk4fK8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    changelog = "https://github.com/rust-motd/rust-motd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rust-motd";
  };
})
