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
  libxrandr,
  libxi,
  libxcursor,
  libx11,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lutgen-studio";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-studio-v${finalAttrs.version}";
    hash = "sha256-8sayt1gLJPdhesUvSoykUYjIiGLRJH5avsRSrWLfIVE=";
  };

  cargoHash = "sha256-CJXobmGOFEOiycrtgKjupVwTCYLMQcEI7RdLGpwmSyg=";

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
        libxcursor
        libxrandr
        libxi
        libx11
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
})
