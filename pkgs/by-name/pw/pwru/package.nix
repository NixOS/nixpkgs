{
  lib,
  buildGoModule,
  fetchFromGitHub,
  clang,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "pwru";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "pwru";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3lIKbzwPX6okJT9CeErX5/innUK3VqnnbWPpvlSN+6U=";
  };

  vendorHash = null;

  nativeBuildInputs = [ clang ];

  buildInputs = [ libpcap ];

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
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.linux;
    mainProgram = "pwru";
  };
})
