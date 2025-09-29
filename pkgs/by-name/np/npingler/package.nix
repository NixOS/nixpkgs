{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npingler";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d34IGZ+Xdzknkmz+JemEEEYde+8zowuGOlGKlm7F3Jk=";
  };

  cargoHash = "sha256-Fs5LPy9dX2hRyMo/YASQesXQoklqYDV78eXnlecet0E=";

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
})
