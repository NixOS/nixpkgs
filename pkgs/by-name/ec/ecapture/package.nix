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
  postgresql,
  bash,
  nix-update-script,
  llvmPackages,
  withNonBTF ? false,
  kernel ? null,
}:

buildGoModule rec {
  pname = "ecapture";
  version = "2.11.0";

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

  newlibpcap = libpcap.overrideAttrs (previousAttrs: {
    configureFlags = previousAttrs.configureFlags ++ [ "--without-libnl" ];
  });

  buildInputs = [
    newlibpcap
    glibc.static
    glibc
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

  postPatch = ''
    substituteInPlace cli/cmd/postgres.go \
      --replace-fail '/usr/bin/postgres' '${postgresql}/bin/postgres'
    patchShebangs .
  '';

  postConfigure = ''
    sed -i '/git/d' Makefile
    sed -i '/git/d' variables.mk

    substituteInPlace Makefile \
      --replace-fail '/bin/bash' '${lib.getExe bash}'
  ''
  + lib.optionalString withNonBTF ''
    substituteInPlace variables.mk \
      --replace-fail "-emit-llvm" "-emit-llvm -I${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/include -Wno-error=implicit-function-declaration"
    KERN_BUILD_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build KERN_SRC_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source make ebpf_noncore
  ''
  + ''
    make ebpf
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCheckLatest"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
