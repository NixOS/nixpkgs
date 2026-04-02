{
  lib,
  buildGoModule,
  fetchFromGitHub,
  clang,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "pwru";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "pwru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P4CKQOSpRujrgBVVNj1DD1jHoN7DEZ18PrfSOKSd31Y=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  nativeBuildInputs = [ clang ];

  buildInputs = [ libpcap ];

  ldflags = [
    "-X github.com/cilium/pwru/internal/pwru.Version=v${finalAttrs.version}"
  ];

  postPatch = ''
    substituteInPlace internal/libpcap/compile.go \
      --replace "-static" ""
  '';

  # this breaks go generate as bpf does not support -fzero-call-used-regs=used-gpr
  hardeningDisable = [ "zerocallusedregs" ];

  preBuild = ''
    TARGET_GOARCH="$GOARCH" GOOS= GOARCH= go generate
  '';

  meta = {
    description = "eBPF-based Linux kernel networking debugger";
    homepage = "https://github.com/cilium/pwru";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nickcao
      miniharinn
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pwru";
  };
})
