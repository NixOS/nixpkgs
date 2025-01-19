{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  pango,
  librsvg,
}:

rustPlatform.buildRustPackage rec {
  pname = "regreet";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = version;
    hash = "sha256-PYBRfBdy6+cv3VKBFu5RUec/yfuKrAEkRxpanihIt1E=";
  };

  cargoHash = "sha256-SUIyekcuDbPIh/9+EKaAoep9hZDJv8BW+ovtWyDqiCI=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    gtk4
    pango
    librsvg
  ];

  meta = {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
    mainProgram = "regreet";
  };
}
