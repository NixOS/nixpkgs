{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "live-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FKX1rbRKWkWsxzJZDicVAUqrHBwEe2o7EXIouK74UMA=";
  };

  cargoHash = "sha256-gaBYnhljcMqSEPViaOPMtuHjoDP8iY64UizlfK+fcQA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local network server with live reload feature for static pages";
    downloadPage = "https://github.com/lomirus/live-server/releases";
    homepage = "https://github.com/lomirus/live-server";
    changelog = "https://github.com/lomirus/live-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "live-server";
    maintainers = with lib.maintainers; [
      philiptaron
      doronbehar
    ];
    platforms = lib.platforms.unix;
  };
})
