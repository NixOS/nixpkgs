{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg2-sm5";
  version = "1.1.0-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "JoseVarelaP";
    repo = "In-The-Groove2-SM5";
    rev = "07a71151b7170080902c3bf8118950ee4f410c01";
    hash = "sha256-SpYR6U/ujQ7toHIgCp+ogF1LdnH41ikshEdEjhMxlj4=";
  };

  postInstall = ''
    mkdir -p "$out/itgmania/Themes/ITG2-SM5"
    mv * "$out/itgmania/Themes/ITG2-SM5"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Semi-Conversion/Recreation of In The Groove 1 & 2 to StepMania 5";
    homepage = "https://github.com/JoseVarelaP/In-The-Groove2-SM5";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
