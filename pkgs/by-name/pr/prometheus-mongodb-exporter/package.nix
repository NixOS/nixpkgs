{
  lib,
  buildGoModule,
  fetchFromGitHub,
  krb5,
  withGssapi ? true,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-JmUWxiLKRd7ogXduCAuHCq0QayQxeoYlWXrzS/ZxWeQ=";
  };

  vendorHash = "sha256-o4ts3K+wWCO+WnyBsN1GFiEh2MG3l3C5pMxkTvhj4hU=";

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
