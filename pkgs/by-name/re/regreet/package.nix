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
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regreet";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = finalAttrs.version;
    hash = "sha256-f8Xvno5QqmWz4SUiFYDvs8lFU1ZaqQ8gpTaVzWxW4T8=";
  };

  cargoHash = "sha256-abCQ3RsnZ/a1DbjQFOiA7Xs7bbqSJxwNps8yV6Q4FIw=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
    mainProgram = "regreet";
  };
})
