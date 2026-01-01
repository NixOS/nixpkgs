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
<<<<<<< HEAD
  version = "20251216.1";
=======
  version = "20250919.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-pMHkgB7z4coXS9N8+bBCo0gqtNKrXQO1qOTi4pNo19Y=";
  };

  cargoHash = "sha256-7FVjWiNzAQTN9ITmdoRZaQRnwg+epJyphil1e8QAHfo=";
=======
    hash = "sha256-IbWURGWiCRjTJSD8qPc1TmJeOm/WdCAFuK57laIXfXY=";
  };

  cargoHash = "sha256-Px/TlR3BhiFCv73v06VNq0/W0bQM/ORRE/9ndv5hbpY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
