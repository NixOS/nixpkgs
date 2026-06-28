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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zfjAdInF/Sy9FRALlwGtEvp2K9xCReqpbMvVNPho+Ic=";
  };

  cargoHash = "sha256-DWt98XoLBShfhfFu1mI7f5Ke/jDIjtllWSpYPS1Sygc=";

  # Tests require network access and a running Steam client. Skipping.
  doCheck = false;

  nativeBuildInputs = [
    glib
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

  postInstall = ''
    install -Dm644 assets/org.samrewritten.SamRewritten.gschema.xml \
      $out/share/glib-2.0/schemas/org.samrewritten.SamRewritten.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

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
