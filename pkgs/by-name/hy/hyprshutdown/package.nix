{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprtoolkit,
  hyprutils,
  pixman,
  libdrm,
  glaze,
  aquamarine,
  hyprgraphics,
  cairo,
  nix-update-script,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshutdown";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    rev = "89e23430308553db4decc34aaa3a9de42cbb33cb";
    hash = "sha256-6Gzny0DtzD3f5WU6io5OLU9UlJaNBXfcbIiXNPWA9mk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprtoolkit
    hyprutils
    pixman
    libdrm
    aquamarine
    hyprgraphics
    cairo
    (glaze.override { enableSSL = false; })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A graceful shutdown utility for Hyprland";
    homepage = "https://github.com/hyprwm/hyprshutdown";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mithicspirit
    ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprshutdown";
    platforms = lib.platforms.linux;
  };
})
