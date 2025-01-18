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

  cargoHash = "sha256-hEJb1SOQ3daY2otroCds8zitoodSjRyRTyR7GwF8dgk=";

  meta = with lib; {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
}
