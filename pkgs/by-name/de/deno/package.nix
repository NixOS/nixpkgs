{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  yq,
  protobuf,
  installShellFiles,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  libffi,
  sqlite,
  lld,
  writableTmpDirAsHomeHook,

  # Test deps
  curl,
  nodejs,
  git,
  python3,
  esbuild,
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deno";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = "deno";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true; # required for tests
    hash = "sha256-YEiqp5KwkzRB/b6HhAtxXJNxHsPMTf3LnNxkP6GgYKw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WQle7a2OjZ5kNg/eCQo0USPZssMaifiXGhlnKJDEtsQ=";

  patches = [
    ./tests-replace-hardcoded-paths.patch
    ./tests-darwin-differences.patch
    ./tests-no-chown.patch
  ];
  postPatch =
    ''
      # Use patched nixpkgs libffi in order to fix https://github.com/libffi/libffi/pull/857
      tomlq -ti '.workspace.dependencies.libffi = { "version": .workspace.dependencies.libffi, "features": ["system"] }' Cargo.toml
    ''
    +
      lib.optionalString
        (stdenv.hostPlatform.isLinux || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64))
        ''
          # LTO crashes with the latest Rust + LLVM combination.
          # https://github.com/rust-lang/rust/issues/141737
          # TODO: remove this once LLVM is upgraded to 20.1.7
          tomlq -ti '.profile.release.lto = false' Cargo.toml
        '';

  buildInputs = [
    libffi
    sqlite
  ];

  # uses zlib-ng but can't dynamically link yet
  # https://github.com/rust-lang/libz-sys/issues/158
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    # for tomlq to adjust Cargo.toml
    yq
    # required by libz-ng-sys crate
    cmake
    # required by deno_kv crate
    protobuf
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ lld ];

  configureFlags = lib.optionals stdenv.cc.isClang [
    # This never worked with clang, but became a hard error recently: https://github.com/llvm/llvm-project/commit/3d5b610c864c8f5980eaa16c22b71ff1cf462fae
    "--disable-multi-os-directory"
  ];

  buildFlags = [ "--package=cli" ];

  # work around "error: unknown warning group '-Wunused-but-set-parameter'"
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unknown-warning-option";
  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  env.RUSTY_V8_ARCHIVE = librusty_v8;

  # Many tests depend on prebuilt binaries being present at `./third_party/prebuilt`.
  # We provide nixpkgs binaries for these for all platforms, but the test runner itself only handles
  # these four arch+platform combinations.
  doCheck =
    stdenv.hostPlatform.isDarwin
    || (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isx86_64));

  preCheck =
    # Provide esbuild binary at `./third_party/prebuilt/` just like upstream:
    # https://github.com/denoland/deno_third_party/tree/master/prebuilt
    # https://github.com/denoland/deno/blob/main/tests/util/server/src/servers/npm_registry.rs#L402
    let
      platform =
        if stdenv.hostPlatform.isLinux then
          "linux64"
        else if stdenv.hostPlatform.isDarwin then
          "mac"
        else
          throw "Unsupported platform";
      arch =
        if stdenv.hostPlatform.isAarch64 then
          "aarch64"
        else if stdenv.hostPlatform.isx86_64 then
          "x64"
        else
          throw "Unsupported architecture";
    in
    ''
      mkdir -p ./third_party/prebuilt/${platform}
      cp ${lib.getExe esbuild} ./third_party/prebuilt/${platform}/esbuild-${arch}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Unset the env var defined by bintools-wrapper because it triggers Deno's sandbox protection in some tests.
      # ref: https://github.com/denoland/deno/pull/25271
      unset LD_DYLD_PATH
    '';

  cargoTestFlags = [
    "--lib" # unit tests
    "--test integration_tests"
    # Test targets not included here:
    # - node_compat: there are tons of network access in them and it's not trivial to skip test cases.
    # - specs: this target uses a custom test harness that doesn't implement the --skip flag.
    #   refs:
    #   - https://github.com/denoland/deno/blob/2212d7d814914e43f43dfd945ee24197f50fa6fa/tests/Cargo.toml#L25
    #   - https://github.com/denoland/file_test_runner/blob/9c78319a4e4c6180dde0e9e6c2751017176e65c9/src/collection/mod.rs#L49
  ];
  checkFlags =
    [
      # Internet access
      "--skip=check::ts_no_recheck_on_redirect"
      "--skip=js_unit_tests::quic_test"
      "--skip=js_unit_tests::net_test"
      "--skip=node_unit_tests::http_test"
      "--skip=node_unit_tests::http2_test"
      "--skip=node_unit_tests::net_test"
      "--skip=node_unit_tests::tls_test"
      "--skip=npm::lock_file_lock_write"

      # GPU access
      "--skip=js_unit_tests::webgpu_test"
      "--skip=js_unit_tests::jupyter_test"

      # Use of /usr/bin
      "--skip=specs::permission::proc_self_fd"

      # Flaky
      "--skip=init::init_subcommand_serve"
      "--skip=serve::deno_serve_parallel"
      "--skip=js_unit_tests::stat_test" # timing-sensitive
      "--skip=repl::pty_complete_imports"
      "--skip=repl::pty_complete_expression"

      # Test hangs, needs investigation
      "--skip=repl::pty_complete_imports_no_panic_empty_specifier"

      # Use of VSOCK, might not be available on all platforms
      "--skip=js_unit_tests::serve_test"
      "--skip=js_unit_tests::fetch_test"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Expects specific shared libraries from macOS to be linked
      "--skip=shared_library_tests::macos_shared_libraries"

      # Darwin sandbox issues
      "--skip=watcher"
      "--skip=node_unit_tests::_fs_watch_test"
      "--skip=js_unit_tests::fs_events_test"
    ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    curl
    nodejs
    git
    python3
  ];

  preInstall = ''
    # Delete generated shared libraries that aren't needed in the final package
    find ./target \
      -name "libswc_common${stdenv.hostPlatform.extensions.sharedLibrary}" -o \
      -name "libtest_ffi${stdenv.hostPlatform.extensions.sharedLibrary}" -o \
      -name "libtest_napi${stdenv.hostPlatform.extensions.sharedLibrary}" \
      -delete
  '';

  postInstall = ''
    # Remove non-essential binaries like denort and test_server
    find $out/bin/* -not -name "deno" -delete

    ${lib.optionalString canExecute ''
      installShellCompletion --cmd deno \
        --bash <($out/bin/deno completions bash) \
        --fish <($out/bin/deno completions fish) \
        --zsh <($out/bin/deno completions zsh)
    ''}
  '';

  doInstallCheck = canExecute;
  installCheckPhase = lib.optionalString canExecute ''
    runHook preInstallCheck
    $out/bin/deno --help
    $out/bin/deno --version | grep "deno ${finalAttrs.version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update/update.ts;
  passthru.tests = callPackage ./tests { };

  meta = with lib; {
    homepage = "https://deno.land/";
    changelog = "https://github.com/denoland/deno/releases/tag/v${finalAttrs.version}";
    description = "Secure runtime for JavaScript and TypeScript";
    longDescription = ''
      Deno aims to be a productive and secure scripting environment for the modern programmer.
      Deno will always be distributed as a single executable.
      Given a URL to a Deno program, it is runnable with nothing more than the ~15 megabyte zipped executable.
      Deno explicitly takes on the role of both runtime and package manager.
      It uses a standard browser-compatible protocol for loading modules: URLs.
      Among other things, Deno is a great replacement for utility scripts that may have been historically written with
      bash or python.
    '';
    license = licenses.mit;
    mainProgram = "deno";
    maintainers = with maintainers; [
      jk
      ofalvai
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
