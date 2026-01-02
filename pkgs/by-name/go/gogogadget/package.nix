{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gogogadget";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "VigilantSys";
    repo = "GoGoGadget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dghHtaLvXQwLWdFgvEZmUaXWq1VrD1R7oQuygEYlcjA=";
  };

  vendorHash = "sha256-Eq2W6I0WySfjspDVey+vjOLCsAe9zfdCDFXUZmBYjik=";

  ldflags = [
    "-s"
  ];

  # no version flag or tests

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Single binary collection of tools useful for penetration testers and system administrators";
    homepage = "https://github.com/VigilantSys/GoGoGadget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "gogogadget";
  };
})
