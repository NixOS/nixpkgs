{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "bdt";
  version = "0.18.0";

  src = pkgs.fetchFromGitHub {
    owner = "datafusion-contrib";
    repo = pname;
    rev = "5c6730a8e3cd43c7847aef76b499197730cded58";
    hash = "sha256-gUKsJwbpMPSO+KPqyJRodrRLjUpTh/y6C2xhrgvJFKk=";
  };

  cargoHash = "sha256-4KrFhchoIB2N89m7HrL0xj2Z+u/6/6Onxa2wIAX18Io=";

  meta = with lib; {
    description = "boring data tool. A CLI tool to query parquet, json and avro files.";
    homepage = "https://github.com/datafusion-contrib/bdt";
    license = licenses.asl20;
    maintainers = [];
  };
}
