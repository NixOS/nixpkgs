{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "efmt";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = version;
    hash = "sha256-3CL9NcwDsAs6fHUWA/ibkwqOW0Ur4glpHVZTrfLQUXs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5cGnbIF2HrpYhoMvcLHRj3O5L2vP5O5nvtJ0hUf6yTY=";

  meta = {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
}
