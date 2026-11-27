{
  lib,
  buildGoModule,
  fetchFromGitHub,
  krb5,
  withGssapi ? true,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-Avcw3zDCOvLXTX543QWV85ToGuTox23rKcEBr5tQr28=";
  };

  vendorHash = "sha256-osZ9M8BNkMBrGHj1Xe7GMvAtxlpR4hNNlDaAmOXw3w4=";

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
