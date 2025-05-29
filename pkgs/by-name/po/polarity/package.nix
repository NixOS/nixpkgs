{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "b715e6529210242d79f304d34170eba8473174b2";
    hash = "sha256-/yq6fqjkZoEw4MhsOWlRdQciA/Wqds9TgCczcVQV8Rw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-23qr4bEAsN75ONnNmym9eWH38fRoMmP1EkmOaka73Ko=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

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
