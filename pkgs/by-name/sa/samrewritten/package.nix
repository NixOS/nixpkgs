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
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IUiEr9JfxZb3FBfQGoN3Ck7I7Ypk6SGIlI2oj3sbsvc=";
  };

  cargoHash = "sha256-XA/7wcYUmDf0+Ku3vSpzpuRBZGepiH5+dYgOh2T0Akw=";

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
