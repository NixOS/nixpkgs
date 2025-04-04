{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lon";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-VGvK0ahBl440NMs03WqmP7T4a1DP13yfX47YI84rlGU=";
  };

  sourceRoot = "source/rust/lon";

  useFetchCargoVendor = true;
  cargoHash = "sha256-YzQ6A1dH2D56/3inAmsE6G5rCnpWhDawxk6+FMWfhkc=";

  meta = {
    description = "Lock & update Nix dependencies";
    homepage = "https://github.com/nikstur/lon";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.mit;
    mainProgram = "lon";
  };
}
