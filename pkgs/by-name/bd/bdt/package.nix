{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "bdt";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "datafusion-contrib";
    repo = "bdt";
    rev = "5c6730a8e3cd43c7847aef76b499197730cded58";
    hash = "sha256-gUKsJwbpMPSO+KPqyJRodrRLjUpTh/y6C2xhrgvJFKk=";
  };

  cargoHash = "sha256-TikWh0U56x3HKca5Dj68Z59mOgedv+K5r+y7/CcpWa8=";

  meta = with lib; {
    description = "CLI tool to query parquet, json and avro files";
    homepage = "https://github.com/datafusion-contrib/bdt";
    license = licenses.asl20;
    mainProgram = "bdt";
    maintainers = with maintainers; [ matthiasq ];
  };
}
