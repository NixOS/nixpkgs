{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  rust-bindgen,
  llvmPackages ? rustc.llvmPackages,
  pkg-config,
  stdenv,
  glib,
  glibc,
  icu,
  python3,
  gn,
  ninja,
  xcbuild,
  apple-sdk_15,
  symlinkJoin,
  deno,
}:
let
  cc = stdenv.cc.cc;

  rustToolchain = symlinkJoin {
    name = "rusty-v8-rust-toolchain";
    paths = [
      rustc
      rust-bindgen
    ];
    postBuild = ''
      echo "rustc $(${lib.getExe' rustc "rustc"} --version | cut -d' ' -f2)" > "$out/VERSION"
    '';
  };

  clangBasePath = symlinkJoin {
    name = "rusty-v8-llvm-toolchain";
    paths = [
      llvmPackages.clang-unwrapped.lib
      llvmPackages.clang
      llvmPackages.llvm
      llvmPackages.lld
    ];
    postBuild =
      if stdenv.targetPlatform.isDarwin then
        ''
          dir="$out/lib/clang/${lib.versions.major llvmPackages.clang.version}/lib/darwin/"
          mkdir -p "$dir"
          ln -s ${llvmPackages.compiler-rt}/lib/darwin/libclang_rt.osx* "$dir/libclang_rt.osx${stdenv.hostPlatform.extensions.staticLibrary}"
        ''
      else
        ''
          dir="$out/lib/clang/${lib.versions.major llvmPackages.clang.version}/lib/${stdenv.hostPlatform.config}/"
          mkdir -p "$dir"
          ln -s ${llvmPackages.compiler-rt}/lib/linux/libclang_rt.builtins-* "$dir/libclang_rt.builtins${stdenv.hostPlatform.extensions.staticLibrary}"
        '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusty-v8";
  version = "145.0.0";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-uFB5Ao92c4tTTpEli5se8I9fvBrNHrDV3sbxJDokp/M=";
  };

  patches = [
    ./librusty_v8_no_downloads.patch
  ];

  postPatch = ''
    # Provide third_party/rust-toolchain with required binaries
    ln -s ${rustToolchain} third_party/rust-toolchain
  '';

  cargoHash = "sha256-YlEn1fUmIELz+80EMM4fc2BWG0y/700SIiNs8GIOtoY=";

  nativeBuildInputs = [
    python3
    pkg-config
    llvmPackages.lld
  ]
  ++ lib.optional stdenv.targetPlatform.isDarwin [
    xcbuild
  ];
  buildInputs = [
    glib
    icu
  ]
  ++ lib.optional stdenv.targetPlatform.isDarwin [
    apple-sdk_15
  ];

  env = {
    V8_FROM_SOURCE = 1;
    PYTHON = "python3";
    NINJA = lib.getExe ninja;
    GN = lib.getExe gn;
    EXTRA_GN_ARGS = lib.concatStringsSep " " (
      [
        "use_sysroot=false"
        "clang_version=\"${lib.versions.major llvmPackages.clang.version}\""
        "v8_enable_temporal_support=false"
      ]
      ++ lib.optional stdenv.targetPlatform.isDarwin "mac_deployment_target=\"${stdenv.targetPlatform.darwinMinVersion}\""
    );
    BINDGEN_EXTRA_CLANG_ARGS = lib.concatStringsSep " " (
      [
        "-I${cc}/include/c++/${cc.version}"
        "-I${cc}/include/c++/${cc.version}/${stdenv.targetPlatform.config}"
        "-I${llvmPackages.clang-unwrapped.lib}/lib/clang/${lib.versions.major llvmPackages.clang.version}/include"
        "-Wno-invalid-constexpr"
      ]
      ++ lib.optional (!stdenv.targetPlatform.isDarwin) "-I${glibc.dev}/include"
    );
    RUSTFLAGS = "-L${cc.lib}/lib";
    LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang ];
    CLANG_BASE_PATH = clangBasePath;
  };

  checkFlags = [
    # These tests probably fail due to a more recent rustc version (upstream: 1.89.0, here: 1.93.0)
    "--skip=ui"
    "--skip=scope"
  ];

  installPhase = ''
    runHook preInstall

    cp target/*/release/gn_out/obj/librusty_v8${stdenv.hostPlatform.extensions.staticLibrary} $out

    runHook postInstall
  '';

  meta = {
    description = "Rust bindings for the V8 JavaScript engine";
    homepage = "https://github.com/denoland/rusty_v8";
    license = lib.licenses.mit;
    maintainers = deno.meta.maintainers;
    platforms = deno.meta.platforms;
  };
})
