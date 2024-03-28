{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bdt";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "datafusion-contrib";
    repo = "bdt";
    rev = "5c6730a8e3cd43c7847aef76b499197730cded58";
    hash = "sha256-gUKsJwbpMPSO+KPqyJRodrRLjUpTh/y6C2xhrgvJFKk=";
  };

  cargoHash = "sha256-4KrFhchoIB2N89m7HrL0xj2Z+u/6/6Onxa2wIAX18Io=";

  meta = {
    description = "boring data tool. A CLI tool to query parquet, json and avro files";
    homepage = "https://github.com/datafusion-contrib/bdt";
    license = lib.licenses.asl20;
    mainProgram = "bdt";
    maintainers = [];
  };
}
