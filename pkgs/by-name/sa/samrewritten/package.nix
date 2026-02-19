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
  version = "20251229.1";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    tag = finalAttrs.version;
    hash = "sha256-E5/h14QnAAkZOrFmrXo457t1cPPNnRTka+CJ1Psor7A=";
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

  env.PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

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
