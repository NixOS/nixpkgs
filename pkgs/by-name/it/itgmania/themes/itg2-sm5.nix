{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "itg2-sm5";
  version = "1.1.0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "JoseVarelaP";
    repo = "In-The-Groove2-SM5";
    rev = "e25f1a44efa55cd2247891f40633403910b75d21";
    hash = "sha256-FMyT7ZA/1cqiClXDvD7CmJlOFaaWnPLuOuei6fsbzg8=";
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
