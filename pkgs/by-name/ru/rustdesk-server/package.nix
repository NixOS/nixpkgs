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

rustPlatform.buildRustPackage rec {
  pname = "rustdesk-server";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk-server";
    tag = version;
    hash = "sha256-1qSgTIccMkrg9Cr0FZ2eb32GjXpRB01b/b/YV4Er6MA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-NCIKf1SO1AcBciXweuCyeSBffQ3MeCHj4ALpjuarpWA=";

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
      inherit version;
      package = rustdesk-server;
      command = "hbbr --version";
    };
  };

  meta = {
    description = "RustDesk Server Program";
    homepage = "https://github.com/rustdesk/rustdesk-server";
    changelog = "https://github.com/rustdesk/rustdesk-server/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
