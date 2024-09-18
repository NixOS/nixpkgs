{ lib
, buildGoModule
, fetchFromGitHub
, clang
, libpcap
}:

buildGoModule rec {
  pname = "pwru";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "pwru";
    rev = "v${version}";
    hash = "sha256-BjiFuM06YDlPyB578p2hweBay+4z0bOn7fUoxSvrDY8=";
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

  meta = with lib; {
    description = "eBPF-based Linux kernel networking debugger";
    homepage = "https://github.com/cilium/pwru";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
    mainProgram = "pwru";
  };
}
