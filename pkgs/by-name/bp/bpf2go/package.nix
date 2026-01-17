{
  lib,
  buildGoModule,
  fetchFromGitHub,
  clang,
  llvmPackages,
}:

buildGoModule rec {
  pname = "bpf2go";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "ebpf";
    rev = "v${version}";
    hash = "sha256-rb2fkVF5/fQLzil+Ns8VeeC785kFWLWrDt92VNcMWk0=";
  };

  vendorHash = "sha256-PEkr+uL/hO2fKYGt+IgRghWFH75mv54uyhi0D3JPhAc=";

  subPackages = [ "cmd/bpf2go" ];

  # Tests require clang and llvm-strip; run via passthru.tests instead
  doCheck = false;

  passthru.tests.bpf2go = buildGoModule {
    pname = "bpf2go-tests";
    inherit version src vendorHash;

    subPackages = [ "cmd/bpf2go" ];

    nativeCheckInputs = [
      clang
      llvmPackages.bintools
    ];

    # eBPF targets don't support -fzero-call-used-regs
    hardeningDisable = [ "zerocallusedregs" ];

    doCheck = true;

    # TestRun cross-compiles for multiple architectures and needs network access
    checkFlags = [ "-skip=^TestRun$" ];

    # Don't install anything, just run tests
    installPhase = "touch $out";
  };

  meta = {
    description = "Generate Go bindings for eBPF programs";
    homepage = "https://github.com/cilium/ebpf";
    changelog = "https://github.com/cilium/ebpf/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bpf2go";
    platforms = lib.platforms.linux;
  };
}
