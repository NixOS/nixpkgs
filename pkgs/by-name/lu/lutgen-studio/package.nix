{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,

  fontconfig,
  libGL,
  libxkbcommon,
  openssl,
  wayland,
  xorg,

  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen-studio";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-studio-v${version}";
    hash = "sha256-ENhaJTbaAv52YFNjce9Ln/LQvP/Nw2Tk5eMmr8mKwQ0=";
  };

  cargoHash = "sha256-PEso+fTH1DndRUPULYIDMAqnrfz8W9iVVxZ7W2N/I5U=";

  cargoBuildFlags = [
    "--bin"
    "lutgen-studio"
  ];
  cargoTestFlags = [
    "-p"
    "lutgen-studio"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall =
    let
      # Include dynamically loaded libraries
      LD_LIBRARY_PATH = lib.makeLibraryPath [
        fontconfig
        libGL
        libxkbcommon
        openssl
        wayland
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXi
        xorg.libX11
      ];
    in
    ''
      wrapProgram "$out/bin/lutgen-studio" \
        --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}"
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^lutgen-studio-v([0-9.]+)$" ];
  };

  meta = {
    description = "Official GUI for Lutgen, the best way to apply popular colorschemes to any image or wallpaper";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with lib.maintainers; [ ozwaldorf ];
    mainProgram = "lutgen-studio";
    license = lib.licenses.mit;
  };
}
