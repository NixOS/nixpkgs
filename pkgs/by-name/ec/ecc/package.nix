{ lib
, makeWrapper
, fetchFromGitHub
, rustPackages
, pkg-config
, elfutils
, zlib
}:
let
  inherit (rustPackages.rustc) llvmPackages;
  inherit (rustPackages) rustPlatform;
  bpftool = llvmPackages.stdenv.mkDerivation {
    pname = "bpftool";
    version = "unstable-2023-03-11";

    # this fork specialized for some functions
    # and has eventually been embedded into the ecc binary
    src = fetchFromGitHub {
      owner = "eunomia-bpf";
      repo = "bpftool";
      rev = "05940344f5db18d0cb1bc1c42e628f132bc93123";
      hash = "sha256-g2gjixfuGwVnFlqCMGLWVPbtKOSpQI+vZwIZciXFPTc=";
      fetchSubmodules = true;
    };

    buildInputs = [
      llvmPackages.libllvm
      elfutils
      zlib
    ];

    buildPhase = ''
      make -C src
    '';

    installPhase = ''
      # We don't use the default `make install` because we are looking to create a
      # directory structure compatible with `build.rs` of `ecc`.
      mkdir -p $out/src/libbpf
      # some headers are required
      cp -r src/libbpf/include $out/src/libbpf
      cp src/bpftool $out/src
    '';
  };

  vmlinux-headers = fetchFromGitHub {
    owner = "eunomia-bpf";
    repo = "vmlinux";
    rev = "933f83becb45f5586ed5fd089e60d382aeefb409";
    hash = "sha256-CVEmKkzdFNLKCbcbeSIoM5QjYVLQglpz6gy7+ZFPgCY=";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "ecc";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "eunomia-bpf";
    repo = "eunomia-bpf";
    rev = "v${version}";
    hash = "sha256-UiwS+osyC3gtbQH0bWNsx1p3xYr993/FAZ5d5NKnaBM=";
  };

  sourceRoot = "${src.name}/compiler/cmd";

  cargoHash = "sha256-j2HPSmU/JARfw2mE1IiXFT/dcdxxnp+agC2DN0Kc5nw=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    elfutils
    zlib
  ];

  CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = "gcc";

  preBuild = ''
    # `SANDBOX` defined by upstream to disable build-time network access
    export SANDBOX=1
    # specify dependencies' location
    export VMLINUX_DIR=${vmlinux-headers}
    export BPFTOOL_DIR=${bpftool}
  '';

  preCheck = ''
    export HOME=$NIX_BUILD_TOP
  '';

  checkFlags = [
    # requires network access
    "--skip=bpf_compiler::tests::test_generate_custom_btf"

    # FIXME: requires dynamic link `libclang` or clang binary which are not found in check env
    "--skip=bpf_compiler::tests::test_compile_bpf"
    "--skip=bpf_compiler::tests::test_export_multi_and_pack"
    "--skip=document_parser::test::test_parse_empty"
    "--skip=document_parser::test::test_parse_maps"
    "--skip=document_parser::test::test_parse_progss"
    "--skip=document_parser::test::test_parse_variables"
  ];

  passthru = {
    inherit bpftool;
  };

  postFixup = ''
    wrapProgram $out/bin/ecc-rs \
      --prefix LIBCLANG_PATH : ${llvmPackages.libclang.lib}/lib \
      --prefix PATH : ${lib.makeBinPath (with llvmPackages; [clang bintools-unwrapped])}
  '';

  meta = with lib; {
    homepage = "https://eunomia.dev";
    description = "the eBPF compile toolchain for eunomia-bpf";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
