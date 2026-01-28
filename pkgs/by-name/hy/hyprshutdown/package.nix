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
  testers,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshutdown";
  version = "0-unstable-2026-01-11";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    rev = "0c9cec7809a715c5c9a99a585db0b596bfb96a59";
    hash = "sha256-JMpLic41Jw6kDXXMtj6tEYUMu3QQ0Sg/M8EBxmAwapU=";
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

  passthru = {
    updateScript = nix-update-script {
      # TODO: remove when stable release available
      extraArgs = [ "--version=branch" ];
    };
    tests = {
      help = testers.runCommand {
        name = "${finalAttrs.pname}-help-test";
        nativeBuildInputs = [ finalAttrs.finalPackage ];
        script = ''
          '${finalAttrs.meta.mainProgram}' --help && touch "$out"
        '';
      };
    };
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
