{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "59bd7a2c3c3d0a61b25d3bb85b9d21f7b3fef343";
    hash = "sha256-85uo2GAGxWAWwN2vyhUqwz28Ofb+2eOSuetzovAle+A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QjUTsVwRyyFP60eVa/B58eU6jA//rVCns4tvFrmXMUI=";

  meta = {
    description = "A Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
