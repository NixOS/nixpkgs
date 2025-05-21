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
  version = "1.1.14";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk-server";
    rev = version;
    hash = "sha256-5LRMey1cxmjLg1s9RtVwgPjHjwYLSQHa6Tyv7r/XEQs=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-U1LTnqi2iEsm2U7t0Fr4VJWLo1MdQmeTKrPsNqRWap0=";

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

  meta = with lib; {
    description = "RustDesk Server Program";
    homepage = "https://github.com/rustdesk/rustdesk-server";
    changelog = "https://github.com/rustdesk/rustdesk-server/releases/tag/${version}";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      gaelreyrol
      tjni
    ];
  };
}
