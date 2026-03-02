{
  lib,
  buildGoModule,
  fetchFromGitHub,
  krb5,
  withGssapi ? true,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-KgfJ/o+LsEF4NAlUbNdhg8of/qfaPxnd8+rHlp+URHc=";
  };

  vendorHash = "sha256-1yTSQ3ktAtUfy2nKm98hFX+A7eR0z5FoKbM2vAJQWbU=";

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
