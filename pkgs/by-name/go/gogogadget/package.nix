{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gogogadget";
  version = "0.0.1-unstable-2023-03-30";

  src = fetchFromGitHub {
    owner = "VigilantSys";
    repo = "GoGoGadget";
    rev = "14610e64bc096fcf74a3eb8cc3319120624ab524";
    hash = "sha256-dghHtaLvXQwLWdFgvEZmUaXWq1VrD1R7oQuygEYlcjA=";
  };

  vendorHash = "sha256-Eq2W6I0WySfjspDVey+vjOLCsAe9zfdCDFXUZmBYjik=";

  meta = {
    description = "Single binary collection of tools useful for penetration testers and system administrators";
    homepage = "https://github.com/VigilantSys/GoGoGadget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
