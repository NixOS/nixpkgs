{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  sqlite,
  nix-update-script,
  testers,
  rustdesk-server,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustdesk-server";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk-server";
    tag = finalAttrs.version;
    hash = "sha256-BUXds+MSlOUzH5X0K3RDEoTVU4gmE5vKtQrp/c1gMfQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-mC4Ca8h87CZOiHdQPb9+Z+GoY3hXILvGcBABT7kgz40=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsodium
    sqlite
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = rustdesk-server;
      command = "hbbr --version";
    };
  };

  meta = {
    description = "RustDesk Server Program";
    homepage = "https://github.com/rustdesk/rustdesk-server";
    changelog = "https://github.com/rustdesk/rustdesk-server/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
