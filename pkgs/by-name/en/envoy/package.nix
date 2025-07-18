{
  lib,
  bazel_6,
  bazel-gazelle,
  buildBazelPackage,
  fetchFromGitHub,
  applyPatches,
  stdenv,
  cacert,
  cargo,
  rustc,
  rustPlatform,
  cmake,
  git,
  gn,
  go,
  jdk,
  neovim,
  ninja,
  patchelf,
  python3,
  linuxHeaders,
  nixosTests,
  runCommandLocal,
  gnutar,
  gnugrep,
  envoy,
  breakpointHook,

  # v8 (upstream default), wavm, wamr, wasmtime, disabled
  wasmRuntime ? "wamr",
}:

let
  srcVer = {
    # We need the commit hash, since Bazel stamps the build with it.
    # However, the version string is more useful for end-users.
    # These are contained in a attrset of their own to make it obvious that
    # people should update both.
    version = "1.34.2";
    rev = "c657e59fac461e406c8fdbe57ced833ddc236ee1";
    hash = "sha256-f9JsgHEyOg1ZoEb7d3gy3+qoovpA3oOx6O8yL0U8mhI=";
  };

  # https://github.com/envoyproxy/envoy/blob/e439c73e32dfefff0baa4adedfb268c8742a7617/bazel/repository_locations.bzl#L1161-L1175
  # https://github.com/hsjobeki/nixpkgs/blob/43bceee4fd57058437d9ec90eae7c1b280509653/pkgs/build-support/fetchgithub/default.nix#L4
  com_github_wasmtime = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    # matches version in upstream envoy
    # https://github.com/mccurdyc/envoy/blob/6371b185dee99cd267e61ada6191e97f2406e334/bazel/repository_locations.bzl#L1165
    # 24.0.2 - https://github.com/bytecodealliance/wasmtime/releases/tag/v24.0.2
    rev = "c29a9bb9e23b48a95b0a03f3b90f885ab1252a93";
    sha256 = "sha256-pqPyy1evR+qW0fEwIY4EnPDPwB4bKrym3raSs6jezP4=";
  };

  proxy_wasm_cpp_host = fetchFromGitHub {
    owner = "proxy-wasm";
    repo = "proxy-wasm-cpp-host";
    # matches version in upstream envoy
    # https://github.com/mccurdyc/envoy/blob/6371b185dee99cd267e61ada6191e97f2406e334/bazel/repository_locations.bzl#L1407
    rev = "c4d7bb0fda912e24c64daf2aa749ec54cec99412";
    sha256 = "sha256-NSowlubJ3OK4h2W9dqmzhkgpceaXZ7ore2cRkNlBm5Q=";
  };

  # these need to be updated for any changes to fetchAttrs
  depsHash =
    {
      x86_64-linux = "sha256-CczmVD/3tWR3LygXc3cTAyrMPZUTajqtRew85wBM5mY=";
      aarch64-linux = "sha256-GemlfXHlaHPn1/aBxj2Ve9tuwsEdlQQCU1v57378Dgs=";
    }
    .${stdenv.system} or (throw "unsupported system ${stdenv.system}");

in
buildBazelPackage rec {
  pname = "envoy";
  inherit (srcVer) version;
  bazel = bazel_6;

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "envoyproxy";
      repo = "envoy";
      inherit (srcVer) hash rev;
    };
    # By convention, these patches are generated like:
    # git format-patch --zero-commit --signoff --no-numbered --minimal --full-index --no-signature
    patches = [
      # use system Python, not bazel-fetched binary Python
      ./0001-nixpkgs-use-system-Python.patch

      # use system Go, not bazel-fetched binary Go
      ./0002-nixpkgs-use-system-Go.patch

      # use system C/C++ tools
      ./0003-nixpkgs-use-system-C-C-toolchains.patch

      # bump rules_rust to support newer Rust
      ./0004-nixpkgs-bump-rules_rust-to-0.60.0.patch

      # TODO: These could maybe just be stored directly in the bazel repository cache instead of these patches
      # https://github.com/mccurdyc/envoy/blob/6371b185dee99cd267e61ada6191e97f2406e334/api/bazel/envoy_http_archive.bzl#L4-L9
      # Envoy's Bazel WONT fetch repos that are listed in the existing_rules list
      ./0005-com_github_wasmtime_from_nix.patch
      ./0006-proxy_wasm_cpp_host_from_nix.patch
    ];
    postPatch = ''
      chmod -R +w .
      rm ./.bazelversion
      echo ${srcVer.rev} > ./SOURCE_VERSION
    '';
  };

  postPatch = ''
    sed -i 's,#!/usr/bin/env python3,#!${python3}/bin/python,' bazel/foreign_cc/luajit.patch
    sed -i '/javabase=/d' .bazelrc
    sed -i '/"-Werror"/d' bazel/envoy_internal.bzl

    # https://nixos.org/manual/nixpkgs/unstable/#fun-substitute
    # TODO: These could maybe just be stored directly in the bazel repository cache instead of these patches
    substituteInPlace WORKSPACE --subst-var-by com_github_wasmtime_from_nix ${com_github_wasmtime}
    substituteInPlace WORKSPACE --subst-var-by proxy_wasm_cpp_host_from_nix ${proxy_wasm_cpp_host}

    mkdir -p bazel/nix/
    substitute ${./bazel_nix.BUILD.bazel} bazel/nix/BUILD.bazel \
      --subst-var-by bash "$(type -p bash)"
    ln -sf "${cargo}/bin/cargo" bazel/nix/cargo
    ln -sf "${rustc}/bin/rustc" bazel/nix/rustc
    ln -sf "${rustc}/bin/rustdoc" bazel/nix/rustdoc
    ln -sf "${rustPlatform.rustLibSrc}" bazel/nix/ruststd
    substituteInPlace bazel/dependency_imports.bzl \
      --replace-fail 'crate_universe_dependencies()' 'crate_universe_dependencies(rust_toolchain_cargo_template="@@//bazel/nix:cargo", rust_toolchain_rustc_template="@@//bazel/nix:rustc")' \
      --replace-fail 'crates_repository(' 'crates_repository(rust_toolchain_cargo_template="@@//bazel/nix:cargo", rust_toolchain_rustc_template="@@//bazel/nix:rustc",'

    # patch rules_rust for envoy specifics, but also to support old Bazel
    # (Bazel 6 doesn't have ctx.watch, but ctx.path is sufficient for our use)
    cp ${./rules_rust.patch} bazel/rules_rust.patch
    substituteInPlace bazel/repositories.bzl \
      --replace-fail ', "@envoy//bazel:rules_rust_ppc64le.patch"' ""

    substitute ${./rules_rust_extra.patch} bazel/nix/rules_rust_extra.patch \
      --subst-var-by bash "$(type -p bash)"
    cat bazel/nix/rules_rust_extra.patch bazel/rules_rust.patch > bazel/nix/rules_rust.patch
    mv bazel/nix/rules_rust.patch bazel/rules_rust.patch
  '';

  nativeBuildInputs = [
    cmake
    python3
    gn
    go
    git
    jdk
    ninja
    patchelf
    cacert
    # debugging
    neovim
    breakpointHook
  ];

  buildInputs = [ linuxHeaders ];

  # This is a full derivation on its own
  fetchAttrs = {
    # Has network access to fetch.
    # The fetchAttrs phase creates a content-addressed cache of all dependencies
    # The sha256 here is the hash of the fixed-output derivation
    sha256 = depsHash;
    env.CARGO_BAZEL_REPIN = true;
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    postPatch = ''
      ${postPatch}

      substituteInPlace bazel/dependency_imports.bzl \
        --replace-fail 'crate_universe_dependencies(' 'crate_universe_dependencies(bootstrap=True, ' \
        --replace-fail 'crates_repository(' 'crates_repository(generator="@@cargo_bazel_bootstrap//:cargo-bazel", '
    '';
    preInstall = ''
      # Strip out the path to the build location (by deleting the comment line).
      find $bazelOut/external -name requirements.bzl | while read requirements; do
        sed -i '/# Generated from /d' "$requirements"
      done

      # Remove references to paths in the Nix store.
      sed -i \
        -e 's,${python3},__NIXPYTHON__,' \
        -e 's,${stdenv.shellPackage},__NIXSHELL__,' \
        -e 's,${builtins.storeDir}/[^/]\+/bin/bash,__NIXBASH__,' \
        $bazelOut/external/com_github_luajit_luajit/build.py \
        $bazelOut/external/local_config_sh/BUILD \
        $bazelOut/external/*_pip3/BUILD.bazel \
        $bazelOut/external/rules_rust/util/process_wrapper/private/process_wrapper.sh \
        $bazelOut/external/rules_rust/crate_universe/src/metadata/cargo_tree_rustc_wrapper.sh

      rm -r $bazelOut/external/go_sdk
      rm -r $bazelOut/external/local_jdk
      rm -r $bazelOut/external/bazel_gazelle_go_repository_tools/bin

      # Remove compiled python
      find $bazelOut -name '*.pyc' -delete

      # Remove Unix timestamps from go cache.
      rm -rf $bazelOut/external/bazel_gazelle_go_repository_cache/{gocache,pkg/mod/cache,pkg/sumdb}

      # fix tcmalloc failure https://github.com/envoyproxy/envoy/issues/30838
      sed -i '/TCMALLOC_GCC_FLAGS = \[/a"-Wno-changes-meaning",' $bazelOut/external/com_github_google_tcmalloc/tcmalloc/copts.bzl

      # Install repinned rules_rust lockfile
      cp source/extensions/dynamic_modules/sdk/rust/Cargo.Bazel.lock $bazelOut/external/Cargo.Bazel.lock

      # Don't save cargo_bazel_bootstrap or the crate index cache
      rm -rf $bazelOut/external/cargo_bazel_bootstrap $bazelOut/external/dynamic_modules_rust_sdk_crate_index/.cargo_home $bazelOut/external/dynamic_modules_rust_sdk_crate_index/splicing-output
    '';
  };
  buildAttrs = {
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    dontUseNinjaInstall = true;
    preConfigure = ''
      # Make executables work, for the most part.
      find $bazelOut/external -type f -executable | while read execbin; do
        file "$execbin" | grep -q ': ELF .*, dynamically linked,' || continue
        patchelf \
          --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
          "$execbin" || echo "$execbin"
      done

      ln -s ${bazel-gazelle}/bin $bazelOut/external/bazel_gazelle_go_repository_tools/bin

      sed -i 's,#!/usr/bin/env bash,#!${stdenv.shell},' $bazelOut/external/rules_foreign_cc/foreign_cc/private/framework/toolchains/linux_commands.bzl

      # Add paths to Nix store back.
      sed -i \
        -e 's,__NIXPYTHON__,${python3},' \
        -e 's,__NIXSHELL__,${stdenv.shellPackage},' \
        -e 's,__NIXBASH__,${stdenv.shell},' \
        $bazelOut/external/com_github_luajit_luajit/build.py \
        $bazelOut/external/local_config_sh/BUILD \
        $bazelOut/external/*_pip3/BUILD.bazel \
        $bazelOut/external/rules_rust/util/process_wrapper/private/process_wrapper.sh \
        $bazelOut/external/rules_rust/crate_universe/src/metadata/cargo_tree_rustc_wrapper.sh

      # Install repinned rules_rust lockfile
      cp $bazelOut/external/Cargo.Bazel.lock source/extensions/dynamic_modules/sdk/rust/Cargo.Bazel.lock
    '';
    installPhase = ''
      install -Dm0755 bazel-bin/source/exe/envoy-static $out/bin/envoy
    '';
  };

  removeRulesCC = false;
  removeLocalConfigCc = true;
  removeLocal = false;
  bazelTargets = [ "//source/exe:envoy-static" ];
  bazelBuildFlags =
    [
      "-c opt"
      "--spawn_strategy=standalone"
      "--noexperimental_strict_action_env"
      "--cxxopt=-Wno-error"
      "--linkopt=-Wl,-z,noexecstack"
      "--config=gcc"
      "--verbose_failures"

      # Force use of system Java.
      "--extra_toolchains=@local_jdk//:all"
      "--java_runtime_version=local_jdk"
      "--tool_java_runtime_version=local_jdk"

      # Force use of system Rust.
      "--extra_toolchains=//bazel/nix:rust_nix_aarch64,//bazel/nix:rust_nix_x86_64"

      # undefined reference to 'grpc_core::*Metadata*::*Memento*
      #
      # During linking of the final binary, we see undefined references to grpc_core related symbols.
      # The missing symbols would be instantiations of a template class from https://github.com/grpc/grpc/blob/v1.59.4/src/core/lib/transport/metadata_batch.h
      # "ParseMemento" and "MementoToValue" are only implemented for some types
      # and appear unused and unimplemented for the undefined cases reported by the linker.
      "--linkopt=-Wl,--unresolved-symbols=ignore-in-object-files"

      "--define=wasm=${wasmRuntime}"
    ]
    ++ (lib.optionals stdenv.hostPlatform.isAarch64 [
      # external/com_github_google_tcmalloc/tcmalloc/internal/percpu_tcmalloc.h:611:9: error: expected ':' or '::' before '[' token
      #   611 |       : [end_ptr] "=&r"(end_ptr), [cpu_id] "=&r"(cpu_id),
      #       |         ^
      "--define=tcmalloc=disabled"
    ]);

  bazelFetchFlags = [
    "--define=wasm=${wasmRuntime}"

    # Force use of system Rust.
    "--extra_toolchains=//bazel/nix:rust_nix_aarch64,//bazel/nix:rust_nix_x86_64"

    # https://github.com/bazelbuild/rules_go/issues/3844
    "--repo_env=GOPROXY=https://proxy.golang.org,direct"
    "--repo_env=GOSUMDB=sum.golang.org"
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests = {
    envoy = nixosTests.envoy;
    # tested as a core component of Pomerium
    pomerium = nixosTests.pomerium;

    deps-store-free =
      runCommandLocal "${envoy.name}-deps-store-free-test"
        {
          nativeBuildInputs = [
            gnutar
            gnugrep
          ];
        }
        ''
          touch $out
          tar -xf ${envoy.deps}
          grep -r /nix/store external && status=$? || status=$?
          case $status in
            1)
              echo "No match found."
              ;;
            0)
              echo
              echo "Error: Found references to /nix/store in envoy.deps derivation"
              echo "This is a reproducibility issue, as the hash of the fixed-output derivation"
              echo "will change in case the store path of the input changes."
              echo
              echo "Replace the store path in fetcherAttrs.preInstall."
              exit 1
              ;;
            *)
              echo "An unexpected error occurred."
              exit $status
              ;;
          esac
        '';
  };

  meta = {
    homepage = "https://envoyproxy.io";
    changelog = "https://github.com/envoyproxy/envoy/releases/tag/v${version}";
    description = "Cloud-native edge and service proxy";
    mainProgram = "envoy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
