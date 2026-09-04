{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  libsodium,
  udev,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microclaw";
  version = "0.0.163";

  src = fetchFromGitHub {
    owner = "microclaw";
    repo = "microclaw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iXKAIvMVvr9CbHRwZpJViirxuid9wCMdmQP5eXh+wm4=";
  };

  cargoHash = "sha256-aC6e0EqfCKABdXjXHfwhWcFKMxrNp1UXU4s+543nAP8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      sqlite
      libsodium
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  doCheck = false;

  meta = {
    description = "Multi-channel agent runtime for Telegram, Discord, and Web";
    homepage = "https://github.com/microclaw/microclaw";
    changelog = "https://github.com/microclaw/microclaw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "microclaw";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ everettjf ];
  };
})
