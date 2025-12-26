{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # Deps
  gdk-pixbuf,
  glib,
  graphene,
  gtk4,
  openssl,
  pango,
  pkg-config,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samrewritten";
  version = "20251216.1";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    tag = finalAttrs.version;
    hash = "sha256-pMHkgB7z4coXS9N8+bBCo0gqtNKrXQO1qOTi4pNo19Y=";
  };

  cargoHash = "sha256-7FVjWiNzAQTN9ITmdoRZaQRnwg+epJyphil1e8QAHfo=";

  # Tests require network access and a running Steam client. Skipping.
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    graphene
    gtk4
    openssl
    pango
  ];

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Steam achievements manager for Windows and Linux";
    mainProgram = "samrewritten";
    homepage = "https://github.com/PaulCombal/SamRewritten";
    changelog = "https://github.com/PaulCombal/SamRewritten/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = [ "x86_64-linux" ];
  };
})
