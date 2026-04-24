{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  rustc,
  rustc-unwrapped,
  rust-bindgen,
  rust-analyzer,
  rustfmt,
  cargo,
  clippy,
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
  rustToolchain = symlinkJoin {
    name = "rusty-v8-rust-toolchain";
    paths = [
      rustc
      rustc-unwrapped
      rust-bindgen
      rust-analyzer
      rustfmt
      cargo
      clippy
      llvmPackages.libclang.lib
    ];
    postBuild = ''
      mkdir -p "$out/lib/rustlib/src/rust"
      cp -r '${rustPlatform.rustcSrc}'/* "$out/lib/rustlib/src/rust/"
      chmod u+w "$out/lib/rustlib/src/rust/library/"
      ln -s '${rustPlatform.rustVendorSrc}' "$out/lib/rustlib/src/rust/library/vendor"
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
  version = "147.2.1";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = "rusty_v8";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-HompYzilJ7AC+HXfJJcvPC3L0rQfdAOhMhir/7qDXG8=";
  };

  patches = [
    ./librusty_v8_no_downloads.patch
    (fetchpatch {
      name = "chromium-146-revert-Update-fsanitizer=array-bounds-config.patch";
      # https://chromium-review.googlesource.com/c/chromium/src/+/7539408
      url = "https://chromium.googlesource.com/chromium/src/+/acb47d9a6b56c4889a2ed4216e9968cfc740086c^!?format=TEXT";
      decode = "base64 -d";
      revert = true;
      includes = [ "build/config/compiler/BUILD.gn" ];
      hash = "sha256-0yEK66IEyS8xABDHY4W8oIvl4Ga1JfL1wxQy8PhXyqI=";
    })
    ./librusty_v8_revert_-fno-lifetime-dse.patch
  ]
  ++ lib.optionals stdenv.targetPlatform.isDarwin [
    ./librusty_v8-darwin-fix-__rust_no_alloc_shim_is_unstable_v2.patch
  ];

  cargoHash = "sha256-2h/zATsNngMg0Tvu5oSSveQNfaVbwFbzHndmSyP4Ddo=";

  nativeBuildInputs = [
    llvmPackages.clang
    python3
    pkg-config
    llvmPackages.lld
  ]
  ++ lib.optionals stdenv.targetPlatform.isLinux [
    glibc
  ]
  ++ lib.optionals stdenv.targetPlatform.isDarwin [
    xcbuild
  ];
  buildInputs = [
    glib
    icu
  ]
  ++ lib.optionals stdenv.targetPlatform.isDarwin [
    apple-sdk_15
  ];

  env = {
    V8_FROM_SOURCE = 1;
    PYTHON = "python3";
    NINJA = lib.getExe ninja;
    GN = lib.getExe gn;
    RUSTC_BOOTSTRAP = 1;
    EXTRA_GN_ARGS = lib.concatStringsSep " " (
      [
        "use_sysroot=false" # prevent download of debian sysroot
        "clang_version=\"${lib.versions.major llvmPackages.clang.version}\""
        "rustc_version=\"${rustc.version}\""
        "rust_sysroot_absolute=\"${rustToolchain}\""
        "rust_bindgen_root=\"${rustToolchain}\""
        "use_chromium_rust_toolchain=true"
        # To accomodate our newer rustc compiler
        "removed_rust_stdlib_libs=[\"adler\"]"
        "added_rust_stdlib_libs=[\"adler2\"]"
      ]
      ++ lib.optional stdenv.targetPlatform.isDarwin "mac_deployment_target=\"${stdenv.targetPlatform.darwinMinVersion}\""
    );
    LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang ];
    CLANG_BASE_PATH = clangBasePath;
  };

  buildFeatures = [ "simdutf" ];

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
