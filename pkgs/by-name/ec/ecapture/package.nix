{
  buildGoModule,
  fetchFromGitHub,
  bpftools,
  lib,
  libpcap,
  clang,
  fd,
  go-bindata,
  glibc,
  openssl,
  gnutls,
  nspr,
  bash,
  nix-update-script,
  llvmPackages,
  withNonBTF ? false,
  kernel ? null,
}:
let
  version = "2.11.0";
  newlibpcap = libpcap.overrideAttrs (previousAttrs: {
    configureFlags = previousAttrs.configureFlags ++ [ "--without-libnl" ];
  });
in
buildGoModule {
  pname = "ecapture";
  inherit version;

  src = fetchFromGitHub {
    owner = "gojue";
    repo = "ecapture";
    tag = "v${version}";
    hash = "sha256-kpF2ECFTBnCrxNsD5jALDl5mE8FM+o2h8Qv6XIEKeTc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    llvmPackages.libllvm
    clang
    fd
    bpftools
    go-bindata
  ];

  buildInputs = [
    newlibpcap
    glibc.static
    glibc
  ];

  subPackages = [ "." ];
  # Use same tags as upstream.
  tags = [
    "ebpfassets"
    "netgo"
  ];

  env.CGO_LDFLAGS = toString [
    "-lpcap"
    "-lpthread"
    "-static"
  ];

  ldflags = [
    "-extldflags '-static'"
    "-linkmode=external"
  ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  # Uprobes only fire in processes that run the hooked file. Only
  # set the default location for the libraries in the same Nixpkgs revision link.
  # Leave the mysqld default empty to allow detection with --pid.
  postPatch = ''
    substituteInPlace cli/cmd/tls.go \
      --replace-fail '"libssl", ""' '"libssl", "${lib.getLib openssl}/lib/libssl.so.3"'
    substituteInPlace cli/cmd/gnutls.go \
      --replace-fail '"gnutls", ""' '"gnutls", "${lib.getLib gnutls}/lib/libgnutls.so.30"'
    substituteInPlace cli/cmd/nss.go \
      --replace-fail '"nspr", ""' '"nspr", "${lib.getLib nspr}/lib/libnspr4.so"'

    substituteInPlace cli/cmd/mysqld.go \
      --replace-fail '"/usr/sbin/mariadbd"' '""'
    substituteInPlace cli/cmd/postgres.go \
      --replace-fail '"/usr/bin/postgres"' '""'

    patchShebangs .
  '';

  postConfigure = ''
    substituteInPlace Makefile \
          --replace-fail '$(CMD_GO) run github.com/shuLhan/go-bindata/cmd/go-bindata' go-bindata \
          --replace-fail '/bin/bash' '${lib.getExe bash}'
  ''
  + lib.optionalString withNonBTF ''
    substituteInPlace variables.mk \
      --replace-fail "-emit-llvm" "-emit-llvm -I${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/include -Wno-error=implicit-function-declaration"
    KERN_BUILD_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build KERN_SRC_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source make ebpf_noncore
  ''
  + ''
    make assets_core
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCheckLatest"
        # expects the non-CO-RE bytecode, but only assets_core is embedded
        "TestEmbeddedProbeAssetContracts"
        # require /sys/class/net, which is missing in the sandbox
        "TestConfigTextRaw"
        "TestConfig_ValidateCaptureMode_Text"
        "TestConfig_ValidateCaptureMode_Pcap"
        "TestConfigDecryptOptions"
        "TestConfigDefaultTextSource"
        "TestProbe_PcapngTextDefaultStdout"
        # require /usr/sbin/mysqld
        "TestConfig_Validate"
        "TestProbe_Initialize"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  # The default checkPhase only tests subPackages. Test all packages of the
  # main module instead.
  checkPhase = ''
    runHook preCheck
    # No trim path, cause test files find themself relative.
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    buildGoDir test ./...
    runHook postCheck
  '';

  vendorHash = "sha256-qM5RS9oCA0I+6xPYmgzkH6IXZXnvZAiWuJqn/chj030=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capture SSL/TLS text content without CA certificate Using eBPF";
    changelog = "https://github.com/gojue/ecapture/releases/tag/v${version}";
    homepage = "https://ecapture.cc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "ecapture";
  };
}
