{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  pkgs,
  libbpf,
  libelf,
  libsystemtap,
  libz,
}:

let
  version = "2.4.2";
  tag = "v${version}";
in
buildGoModule.override
  {
    stdenv = pkgs.clangStdenv;
  }
  {
    name = "ebpf_exporter";

    src = fetchFromGitHub {
      inherit tag;
      owner = "cloudflare";
      repo = "ebpf_exporter";
      hash = "sha256-gXzaMx9Z6LzrlDaQnagQIi183uKhJvdYiolYb8P+MIs=";
    };

    vendorHash = "sha256-GhQvPp8baw2l91OUOg+/lrG27P/D4Uzng8XevJf8Pj4=";

    postPatch = ''
      substituteInPlace examples/Makefile \
        --replace-fail "-Wall -Werror" ""
    '';

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
      "-X github.com/prometheus/common/version.Revision=${tag}"
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

    meta = {
      description = "Prometheus exporter for custom eBPF metrics";
      mainProgram = "ebpf_exporter";
      homepage = "https://github.com/cloudflare/ebpf_exporter";
      changelog = "https://github.com/cloudflare/ebpf_exporter/releases/tag/v${tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jpds ];
      platforms = lib.platforms.linux;
    };
  }
