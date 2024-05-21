{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libpulseaudio,
  gtk4-layer-shell,
  gtk4,
  wrapGAppsHook4,
  libxcb,
  installShellFiles,
  enableWayland ? true,
  enableSass ? true,
  enableX11 ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "mixxc";
  version = "0.2.2";

  src = fetchCrate {
    pname = "mixxc";
    inherit version;
    hash = "sha256-Y/9l8t6Vz7yq9T1AyoHnWmIcju1rfcV0S74hiK1fEjo=";
  };

  cargoHash = "sha256-l9inqqUiLObrqd/8pNobwBbLaiPJD39YK/38CWfDh+Q=";

  cargoBuildFlags = [ "--locked" ];

  buildFeatures = [
    (lib.optionals enableWayland "Wayland")
    (lib.optionals enableX11 "X11")
    (lib.optionals enableSass "Sass")
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    wrapGAppsHook4
  ];

  buildInputs = [
    libpulseaudio
    gtk4
    (lib.optionals enableWayland gtk4-layer-shell)
    (lib.optionals enableX11 libxcb)
  ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    installManPage $src/doc/mixxc.1
  '';

  meta = {
    description = "A minimalistic and customizable volume mixer";
    homepage = "https://github.com/Elvyria/mixxc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "mixxc";
    platforms = lib.platforms.linux;
  };
}
