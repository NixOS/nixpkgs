{
  lib,
  clangStdenv,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
  nix-update-script,
  libbpf,
  libelf,
  libsystemtap,
  libz,
}:

# BPF programs must be compiled with Clang
buildGoModule.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "prometheus-ebpf-exporter";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "ebpf_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zIevVZ4ldPj/4OvQFo+Nv/g//xNZEppO9ccB6y65rZA=";
  };

  vendorHash = "sha256-ZwKXIIoV4yEyjSpGjVDr91/CQmVuF9zc0IHkJYraE9o=";

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

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.tag}"
    "-X github.com/prometheus/common/version.Branch=${finalAttrs.src.tag}"
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

  # Tests fail on trying to access cgroups.
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests.prometheus-exporters) ebpf; };
  };

  meta = {
    description = "Prometheus exporter for custom eBPF metrics";
    mainProgram = "ebpf_exporter";
    homepage = "https://github.com/cloudflare/ebpf_exporter";
    changelog = "https://github.com/cloudflare/ebpf_exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
      stepbrobd
    ];
    platforms = lib.platforms.linux;
  };
})
