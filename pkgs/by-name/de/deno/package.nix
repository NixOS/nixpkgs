{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  protobuf,
  installShellFiles,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  libffi,
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = "deno";
    tag = "v${version}";
    hash = "sha256-tJskyj9jbtnrGQ48SUJadTM/ZVmCMbQ+YH/XXtMeyaQ=";
  };

  cargoHash = "sha256-7hO2B0z4h1asWlAHdTNxo/dC8ZX/3XTrqMUft6Aads8=";

  postPatch = ''
    # upstream uses lld on aarch64-darwin for faster builds
    # within nix lld looks for CoreFoundation rather than CoreFoundation.tbd and fails
    substituteInPlace .cargo/config.toml --replace-fail "-fuse-ld=lld " ""

    # Use patched nixpkgs libffi in order to fix https://github.com/libffi/libffi/pull/857
    substituteInPlace ext/ffi/Cargo.toml --replace-fail "libffi = \"=3.2.0\"" "libffi = { version = \"3.2.0\", features = [\"system\"] }"
  '';

  # uses zlib-ng but can't dynamically link yet
  # https://github.com/rust-lang/libz-sys/issues/158
  nativeBuildInputs = [
    # required by libz-ng-sys crate
    cmake
    # required by deno_kv crate
    protobuf
    installShellFiles
  ];

  configureFlags = lib.optionals stdenv.cc.isClang [
    # This never worked with clang, but became a hard error recently: https://github.com/llvm/llvm-project/commit/3d5b610c864c8f5980eaa16c22b71ff1cf462fae
    "--disable-multi-os-directory"
  ];

  buildInputs = [ libffi ];
  buildAndTestSubdir = "cli";

  # work around "error: unknown warning group '-Wunused-but-set-parameter'"
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unknown-warning-option";
  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  env.RUSTY_V8_ARCHIVE = librusty_v8;

  # Tests have some inconsistencies between runs with output integration tests
  # Skipping until resolved
  doCheck = false;

  preInstall = ''
    find ./target -name libswc_common${stdenv.hostPlatform.extensions.sharedLibrary} -delete
  '';

  postInstall = lib.optionalString canExecute ''
    installShellCompletion --cmd deno \
      --bash <($out/bin/deno completions bash) \
      --fish <($out/bin/deno completions fish) \
      --zsh <($out/bin/deno completions zsh)
  '';

  doInstallCheck = canExecute;
  installCheckPhase = lib.optionalString canExecute ''
    runHook preInstallCheck
    $out/bin/deno --help
    $out/bin/deno --version | grep "deno ${version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update/update.ts;
  passthru.tests = callPackage ./tests { };

  meta = with lib; {
    homepage = "https://deno.land/";
    changelog = "https://github.com/denoland/deno/releases/tag/v${version}";
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
}
