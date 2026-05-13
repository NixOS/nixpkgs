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
  versionCheckHook,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshutdown";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-msCMXV9k9+1siOPaxSzNJwx/o8pn2srCR4h0pxyW/WE=";
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A graceful shutdown utility for Hyprland";
    homepage = "https://github.com/hyprwm/hyprshutdown";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mithicspirit ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprshutdown";
    platforms = lib.platforms.linux;
  };
})
