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
  version = "0.2.5";

  src = fetchCrate {
    pname = "mixxc";
    inherit version;
    hash = "sha256-YVh6SOXCf4GHqDduXP7QupC48hcIMQtjIdGJYXNXQ1E=";
  };

  cargoHash = "sha256-w+bHaGt6aq21DpmxYNQIf/YNigfrkqnAI25Q3l/WhHc=";

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
    description = "Minimalistic and customizable volume mixer";
    homepage = "https://github.com/Elvyria/mixxc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "mixxc";
    platforms = lib.platforms.linux;
  };
}
