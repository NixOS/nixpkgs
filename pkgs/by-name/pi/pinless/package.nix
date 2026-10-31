{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  pname = "pinless";
  version = "0-unstable-2026-08-06";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bunk-im";
    repo = "pinless";
    rev = "87b560c911186b64b6337baa2e64658977891c7e";
    hash = "sha256-IVPSFqutAUH4AWnGXjuN81Q004YeaY5sO0uf+/cqC7Q=";
  };

  vendorHash = "sha256-Ef2XLxGq8TO3WVh9EvLE30Is2CBwH4pqXxkq1tcuR0Q=";

  meta = {
    homepage = "https://github.com/bunk-im/pinless";
    description = "Privacy-focused frontend for Pinterest";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.unix;
    mainProgram = "pinless";
  };
}
