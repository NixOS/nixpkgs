{
  lib,
  fetchFromGitHub,
  rustPlatform,
  glib,
  gtk3,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-query-tree-viewer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo = "nix-query-tree-viewer";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Lc9hfjybnRrkd7PZMa2ojxOM04bP4GJyagkZUX2nVwY=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  cargoHash = "sha256-6TdPYN42PMOE5zL8nBRVdndjWhvU+7y0yNWtJybvkf0=";

  meta = {
    description = "GTK viewer for the output of `nix store --query --tree`";
    mainProgram = "nix-query-tree-viewer";
    homepage = "https://github.com/cdepillabout/nix-query-tree-viewer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ cdepillabout ];
    platforms = lib.platforms.unix;
  };
})
