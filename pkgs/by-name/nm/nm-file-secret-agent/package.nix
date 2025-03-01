{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  networkmanager,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  name = "nm-file-secret-agent";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lilioid";
    repo = "nm-file-secret-agent";
    rev = "v${version}";
    hash = "sha256-xQWgNxrbpHOfnKXa57cV1F3JmtJcvQsqUfgwfWg5Ni4=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-Q2RQ6pWYKOr/6nD7PLpTonVldOfyUu2lvwNRAc8zkLg=";
  buildInputs = [ dbus ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NetworkManager secret agent that responds with the content of preconfigured files";
    mainProgram = "nm-file-secret-agent";
    homepage = "https://github.com/lilioid/nm-file-secret-agent/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lilioid ];
    platforms = lib.lists.intersectLists dbus.meta.platforms networkmanager.meta.platforms;
  };
}
