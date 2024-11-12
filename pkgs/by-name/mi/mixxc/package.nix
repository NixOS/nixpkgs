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
  version = "0.2.3";

  src = fetchCrate {
    pname = "mixxc";
    inherit version;
    hash = "sha256-d/bMDqDR+sBtsI3ToCcByDxqd+aE6rDPRvGBcodU6iA=";
  };

  cargoHash = "sha256-RoVqQaSlIvAb8mWJNOyALjCHejFEfxjJADQfHZ5EiOs=";

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
