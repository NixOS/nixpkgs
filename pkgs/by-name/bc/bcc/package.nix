{
  stdenv,
  audit,
  bash,
  bison,
  cmake,
  elfutils,
  fetchFromGitHub,
  flex,
  iperf,
  lib,
  libbpf,
  llvmPackages,
  luajit,
  makeWrapper,
  netperf,
  nixosTests,
  testers,
  python3Packages,
  readline,
  replaceVars,
  zip,
  linuxHeaders,
  openssl,
  libbfd,
  libcap,
}:

let
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-yfIyV+NKaSYMNjqFpxPwCgetPacC8OrBBGxRG3P2z0o=";
  };

  libbpf-tools = stdenv.mkDerivation (finalAttrs: {
    pname = "libbpf-tools";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/libbpf-tools";

    nativeBuildInputs = [
      llvmPackages.llvm
    ];

    buildInputs = [
      llvmPackages.libclang
      elfutils
      openssl
      linuxHeaders
      libbfd
      libcap
    ];

    env.C_INCLUDE_PATH = "${linuxHeaders}/include";

    preBuild = ''
      makeFlagsArray+=(prefix=''${out})
    '';
  });
in
python3Packages.buildPythonApplication rec {
  pname = "bcc";
  inherit version;
  pyproject = false;

  inherit src;

  patches = [
    # This is needed until we fix
    # https://github.com/NixOS/nixpkgs/issues/40427
    ./fix-deadlock-detector-import.patch
    # Quick & dirty fix for bashreadline
    # https://github.com/NixOS/nixpkgs/issues/328743
    ./bashreadline.py-remove-dependency-on-elftools.patch

    (replaceVars ./absolute-ausyscall.patch {
      ausyscall = lib.getExe' audit "ausyscall";
    })
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.netaddr ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    llvmPackages.llvm
    makeWrapper
    zip
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    elfutils
    luajit
    netperf
    iperf
    flex
    bash
    libbpf
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BCC_KERNEL_MODULES_DIR" "/run/booted-system/kernel-modules/lib/modules")
    (lib.cmakeFeature "REVISION" version)
    (lib.cmakeBool "ENABLE_USDT" true)
    (lib.cmakeBool "ENABLE_CPP_API" true)
    (lib.cmakeBool "CMAKE_USE_LIBBPF_PACKAGE" true)
    (lib.cmakeBool "ENABLE_LIBDEBUGINFOD" false)
  ];

  postPatch = ''
    substituteInPlace src/python/bcc/libbcc.py \
      --replace-fail "libbcc.so.0" "$out/lib/libbcc.so.0"

    # https://github.com/iovisor/bcc/issues/3996
    substituteInPlace src/cc/libbcc.pc.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@

    substituteInPlace tools/bashreadline.py \
      --replace-fail '/bin/bash' '${readline}/lib/libreadline.so'
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share
    rm -r $out/share/bcc/tools/old
    mv $out/share/bcc/tools/doc $out/share
    mv $out/share/bcc/man $out/share/

    find $out/share/bcc/tools -type f -executable -print0 | \
    while IFS= read -r -d ''$'\0' f; do
      bin=$out/bin/$(basename $f)
      if [ ! -e $bin ]; then
        ln -s $f $bin
      fi
      substituteInPlace "$f" \
        --replace-quiet '$(dirname $0)/lib' "$out/share/bcc/tools/lib"
    done
  '';

  pythonImportsCheck = [ "bcc" ];

  postFixup = ''
    wrapPythonProgramsIn "$out/share/bcc/tools" "$out ''${pythonPath[*]}"
  '';

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    tests = {
      bpf = nixosTests.bpf;
      libbpf-tools = testers.runCommand {
        name = "bcc-libbpf-tools";
        nativeBuildInputs = [ libbpf-tools ];
        script = ''
          ${lib.getExe' libbpf-tools "syscount"} -h >/dev/null

          touch $out
        '';
      };
    };

    libbpf-tools = libbpf-tools;
  };

  meta = {
    description = "Dynamic Tracing Tools for Linux";
    homepage = "https://iovisor.github.io/bcc/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ragge
      mic92
      thoughtpolice
      martinetd
      ryan4yin
    ];
    platforms = lib.platforms.linux;
  };
}
