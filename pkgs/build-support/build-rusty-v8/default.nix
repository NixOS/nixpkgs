/*
  This is a convenience function to build the given version of rusty-v8.
  Use it for example as follows:

  librusty_v8 = pkgs.buildRustyV8 rec {
    version = "149.3.0";
    src = fetchFromGitHub {
      owner = "denoland";
      repo = "rusty_v8";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-hQfSDpdQBeQrOerXi+fI6mGCXkFH2ro90eWZX7xcwjA=";
    };
    cargoHash = "sha256-ROz8f+o/OVNKSm4Hp1z4eCI2pmlNTUpBZ5447uvVXUk=";
  };

  By re-using the version in the git source, nix-update can automatically update this dependency.
  Look for example in pkgs/by-name/de/deno/update.sh for how to do that.
  You have to add `librusty_v8` to the package passthru attributes for the update to work.
*/

{
  version,
  src,
  cargoHash,
  extraPatches ? [ ],
}:
{
  fetchpatch,
  lib,
  stdenv,
  rustPlatform,
  rustc,
  rustc-unwrapped,
  rust-bindgen,
  rust-analyzer,
  rustfmt,
  cargo,
  clippy,
  pkg-config,
  glib,
  glibc,
  icu,
  libffi,
  python3,
  gn,
  ninja,
  xcbuild,
  apple-sdk_15,
  symlinkJoin,

  llvmPackages ? rustc.llvmPackages,
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

  # Patches enabled based on rusty-v8 version.
  versionedPatches = [
    ./librusty_v8_no_downloads.patch
  ]
  ++ lib.optionals (lib.versionAtLeast version "149.0.0") [
    ./149-gn_inputs_fix.patch
  ]
  ++ lib.optionals (stdenv.targetPlatform.isDarwin && lib.versionAtLeast version "139.0.0") [
    ./139-darwin-fix-__rust_no_alloc_shim_is_unstable_v2.patch
  ];

  derivation = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "rusty-v8";
    inherit version;

    inherit src cargoHash;

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
      libffi
    ]
    ++ lib.optionals stdenv.targetPlatform.isDarwin [
      apple-sdk_15
    ];

    patches = versionedPatches ++ extraPatches;

    postPatch = ''
      # Provide the rust toolchain at the expected location
      ln -sv ${rustToolchain} third_party/rust-toolchain
    ''
    + lib.optionalString (lib.versionOlder llvmPackages.clang.version "22") ''
      # Remove LLVM 22 compiler flags unknown to LLVM 21
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace-quiet '-fno-lifetime-dse' "" \
        --replace-quiet '-fdiagnostics-show-inlining-chain' "" \
        --replace-quiet '-Wno-unsafe-buffer-usage-in-static-sized-array' "" \
        --replace-quiet '-fsanitize-ignore-for-ubsan-feature=array-bounds' ""
      substituteInPlace build/config/sanitizers/sanitizers.gni \
        --replace-quiet '-fsanitize-ignore-for-ubsan-feature=''${invoker.sanitizer}' ""
    '';

    env = {
      V8_FROM_SOURCE = 1;
      PYTHON = "python3";
      NINJA = lib.getExe ninja;
      GN = lib.getExe gn;
      RUSTC_BOOTSTRAP = 1;
      EXTRA_GN_ARGS = lib.concatStringsSep " " (
        [
          "use_system_libffi=true"
          "use_sysroot=false" # prevent download of debian sysroot
          "clang_version=\"${lib.versions.major llvmPackages.clang.version}\""
          "rustc_version=\"${rustc.version}\""
          "rust_sysroot_absolute=\"${rustToolchain}\""
          "rust_bindgen_root=\"${rustToolchain}\""
        ]
        # For older rusty-v8 versions, the V8 build submodule does not handle
        # the adler->adler2 Rust std lib transition natively.
        ++ lib.optionals (lib.versionAtLeast version "145.0.0" && lib.versionOlder version "149.0.0") [
          "use_chromium_rust_toolchain=true"
          "removed_rust_stdlib_libs=[\"adler\"]"
          "added_rust_stdlib_libs=[\"adler2\"]"
        ]
        ++ lib.optional stdenv.targetPlatform.isDarwin "mac_deployment_target=\"${stdenv.targetPlatform.darwinMinVersion}\""
      );
      LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang ];
      CLANG_BASE_PATH = clangBasePath;
    };

    buildFeatures = lib.optionals (lib.versionAtLeast version "149.0.0") [ "simdutf" ];

    hardeningDisable = [
      # rusty-v8 has its own default hardening flags, which are "extensive" for release builds as long as `use_custom_libcxx` stays true.
      # Avoids many warnings about redefined macros (on build failures) and uses the upstream flag.
      "libcxxhardeningfast"
      # from Arch Linux: this uses malloc_usable_size, which is incompatible with fortification level 3
      # https://gitlab.archlinux.org/archlinux/packaging/packages/deno/-/blob/cd9bdf9e67381da413142413646bd8648807510a/PKGBUILD#L49
      "fortify3"
    ];

    # Don't run checks on hydra as they've been observed to be flakey for us and
    # other distros CI: https://gitlab.alpinelinux.org/alpine/aports/-/blob/bec8b026686323b496365b825ad14fdf4473adf2/community/deno/APKBUILD#L79
    # We haven't reproduced it on local machines, could be related to doing other
    # builds simultaneously.
    # A build with tests is included as part of `deno.passhtru.tests` via `librusty_v8.passthru.tests`
    doCheck = false;
    # Check related config is left in the main package so if someone uses
    # `overrideAttrs` to always build with tests, it'll all work.
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

    passthru.tests = {
      build-with-unit-tests = derivation.overrideAttrs (_: {
        doCheck = true;
      });
    };

    requiredSystemFeatures = [ "big-parallel" ];

    meta = {
      description = "Rust bindings for the V8 JavaScript engine";
      homepage = "https://github.com/denoland/rusty_v8";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        jk
        ofalvai
        mynacol
      ];
      maxSilent = 14400; # 4h, double the default of 7200s; sometimes needed for x86_64-darwin on hydra
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  });

in

derivation
