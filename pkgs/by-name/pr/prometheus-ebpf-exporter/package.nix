{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  clang,
  libbpf,
  libelf,
  libsystemtap,
  libz,
}:

buildGoModule rec {
  pname = "ebpf_exporter";
  version = "2.4.2";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "cloudflare";
    repo = "ebpf_exporter";
    sha256 = "sha256-gXzaMx9Z6LzrlDaQnagQIi183uKhJvdYiolYb8P+MIs=";
  };

  vendorHash = "sha256-GhQvPp8baw2l91OUOg+/lrG27P/D4Uzng8XevJf8Pj4=";

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

  hardeningDisable = [ "zerocallusedregs" ];

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
