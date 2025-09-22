{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  pkg-config,
  wrapGAppsHook3,
  openssl,
  gtk3,
  gdk-pixbuf,
  pango,
  atk,
  cairo,
}:

rustPlatform.buildRustPackage rec {
  pname = "castor";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = "castor";
    rev = version;
    sha256 = "sha256-yYLDbxmUR86fdpbHQQTiHVUbicnOD75cl3Vhofw5qr0=";
  };

  cargoHash = "sha256-6X3qZZ1iKXYtl59aGAnd4RzY/kBI4Q8zmX+JYMlKwJU=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    gtk3
    gdk-pixbuf
    pango
    atk
    cairo
  ];

  postInstall = "make PREFIX=$out copy-data";

  useNextest = true;

  meta = with lib; {
    description = "Graphical client for plain-text protocols written in Rust with GTK. It currently supports the Gemini, Gopher and Finger protocols";
    mainProgram = "castor";
    homepage = "https://sr.ht/~julienxx/Castor";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
