{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-06-06";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "421e73a38f57d0453d821332d4e25aa53476254d";
    hash = "sha256-eugXy+BhjshhALT8ZLhA8OvtqCM8wmiuG1yuNWsAGyo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-23qr4bEAsN75ONnNmym9eWH38fRoMmP1EkmOaka73Ko=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
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
