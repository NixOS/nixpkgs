{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, clang
, libbpf
, libelf
, libsystemtap
, libz
}:

buildGoModule rec {
  pname = "ebpf_exporter";
  version = "2.4.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "cloudflare";
    repo = "ebpf_exporter";
    sha256 = "sha256-quIFF0e8O/RagwqVQJrWGV8BRHErevvMJRZ3H0vbWDo=";
  };

  vendorHash = "sha256-2PokkJjsDKdM6QZq/qbZ9DOeeIWUsTbShmnop70xJhM=";

  postPatch = ''
    substituteInPlace examples/Makefile \
      --replace-fail "-Wall -Werror" ""
  '';

  nativeBuildInputs = [
    clang
  ];

  buildInputs = [
    libbpf
    libelf
    libsystemtap
    libz
  ];

  CGO_LDFLAGS = "-l bpf";

  # Tests fail on trying to access cgroups.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  postBuild = ''
    BUILD_LIBBPF=0 make examples
  '';

  postInstall = ''
    mkdir -p $out/examples
    mv examples/*.o examples/*.yaml $out/examples
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) ebpf; };

  meta = with lib; {
    description = "Prometheus exporter for custom eBPF metrics";
    mainProgram = "ebpf_exporter";
    homepage = "https://github.com/cloudflare/ebpf_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ jpds ];
    platforms = platforms.linux;
  };
}
