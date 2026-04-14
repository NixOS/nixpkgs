{
  lib,
  buildGoModule,
  fetchFromGitHub,
  krb5,
  withGssapi ? true,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-vUvm9YvcO3XgQR4GcY1SgP05KGnVZ5c7Z5fZtLvSiFo=";
  };

  vendorHash = "sha256-FS6g2VupTk5oa40gjqFJGA/6Ek1ItCpHHyrnG43tSrw=";

  buildInputs = lib.optionals withGssapi [ krb5 ];

  tags = lib.optionals withGssapi [ "gssapi" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.Branch=unknown"
    "-X main.buildDate=unknown"
  ];

  subPackages = [ "." ];

  # those check depends on docker;
  # nixpkgs doesn't have mongodb application available;
  doCheck = false;

  meta = {
    description = "Prometheus exporter for MongoDB including sharding, replication and storage engines";
    homepage = "https://github.com/percona/mongodb_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ undefined-moe ];
    mainProgram = "mongodb_exporter";
  };
}
