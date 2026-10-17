{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;
  pname = "rustdesk-server-api";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lejianwen";
    repo = "rustdesk-server";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-bIOCuTcA3EYJSxTXBT5l+NgzBDVbaFz9adcJaUH+ilg=";
  };

  cargoHash = "sha256-QThwrV3rFXqesWqy3Rva6NdWSa5nL3KaLIAMdHyZe+c=";
  # Upstream v0.1.2 ships a lockfile predating its hbb_common submodule.
  cargoPatches = [ ./update-cargo-lock.patch ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libsodium
    sqlite
  ];

  meta = {
    description = "RustDesk rendezvous and relay servers with rustdesk-api JWT authentication";
    homepage = "https://github.com/lejianwen/rustdesk-server";
    changelog = "https://github.com/lejianwen/rustdesk-server/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.xiongchenyu6 ];
    platforms = lib.platforms.unix;
    mainProgram = "hbbs";
  };
}
