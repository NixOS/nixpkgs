{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "serf";
  version = "0.10.4";
  rev = "a2bba5676d6e37953715ea10e583843793a0c507";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "serf";
    rev = "v${version}";
    sha256 = "sha256-pLcmNrN38yPr0kPkXZkKkKZK8jrtFmzqnYDAT46FgxA=";
  };

  vendorHash = "sha256-1tIRZybovsSOig3P0n+4G3KIP7B7opqBCkrPTFoOQLU=";

  subPackages = [ "cmd/serf" ];

  # These values are expected by version/version.go
  # https://github.com/hashicorp/serf/blob/7faa1b06262f70780c3c35ac25a4c96d754f06f3/version/version.go#L8-L22
  ldflags = lib.mapAttrsToList (n: v: "-X github.com/hashicorp/serf/version.${n}=${v}") {
    GitCommit = rev;
    Version = version;
    VersionPrerelease = "";
  };

  # There are no tests for cmd/serf.
  doCheck = false;

  meta = {
    description = "Service orchestration and management tool";
    mainProgram = "serf";
    longDescription = ''
      Serf is a decentralized solution for service discovery and orchestration
      that is lightweight, highly available, and fault tolerant.
    '';
    homepage = "https://www.serf.io";
    license = lib.licenses.mpl20;
  };
}
