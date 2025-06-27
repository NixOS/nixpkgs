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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-studio-v${version}";
    hash = "sha256-Oog3qv+Pvo/Ib/fpoIcrExVkkcZj+tX8unH9LZod3YM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+8Sq6Jk914U0Vyr8cKLX++AF41j0R7y76ZG96SZJtxM=";

  cargoBuildFlags = [
    "--bin"
    "lutgen-studio"
  ];
  cargoTestFlags = [
    "-p"
    "lutgen-studio"
  ];

  nativeBuildInputs = [ makeWrapper ];

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

  postInstall = ''
    wrapProgram "$out/bin/lutgen-studio" \
      --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^lutgen-studio-v([0-9.]+)$" ];
  };

  meta = {
    description = "Offical GUI for Lutgen, the best way to apply popular colorschemes to any image or wallpaper";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with lib.maintainers; [ ozwaldorf ];
    mainProgram = "lutgen-studio";
    license = lib.licenses.mit;
  };
}
