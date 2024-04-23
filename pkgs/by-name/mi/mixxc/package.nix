{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libpulseaudio,
  gtk4-layer-shell,
  gtk4,
  libxcb,
  installShellFiles,
  enableWayland ? false,
  enableSass ? false,
  enableX11 ? false,
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
  outputs = ["out" "man"];
  cargoBuildFlags = with lib;
    ["--locked"]
    ++ optionals enableWayland ["--features Wayland"]
    ++ optionals enableX11 ["--features X11"]
    ++ optionals enableSass ["--features Sass"];

  nativeBuildInputs = [pkg-config installShellFiles];

  buildInputs = with lib;
    [libpulseaudio gtk4]
    ++ optionals enableWayland [gtk4-layer-shell]
    ++ optionals enableX11 [libxcb];

  postInstall = ''
    installManPage $src/doc/mixxc.1
  '';

  meta = with lib; {
    description = "A minimalistic and customizable volume mixer";
    homepage = "https://github.com/Elvyria/mixxc";
    license = with licenses; [mit];
    maintainers = with maintainers; [daru-san];
    mainProgram = "mixxc";
    platforms = platforms.linux;
  };
}
