{
  lib,
  fetchFromGitea,
  rustPlatform,
  dbus,
  networkmanager,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  name = "nm-file-secret-agent";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lilly";
    repo = "nm-file-secret-agent";
    rev = "v${version}";
    hash = "sha256-FZef9qMJeQkoLvCHcsGMqr0riC98WVXntQtbt76Iev4=";
  };

  cargoHash = "sha256-HYyL0r9YrDL22uQdypJQ7Xep9Uqt4b16bhl0D9kRByU=";
  buildInputs = [ dbus ];
  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NetworkManager secret agent that responds with the content of preconfigured files";
    mainProgram = "nm-file-secret-agent";
    homepage = "https://codeberg.org/lilly/nm-file-secret-agent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lilioid ];
    platforms = lib.lists.intersectLists dbus.meta.platforms networkmanager.meta.platforms;
  };
}
