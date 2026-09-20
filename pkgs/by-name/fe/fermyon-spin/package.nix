{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  zlib,
  stdenv,
  installShellFiles,
  testers,
  nix-update-script,
  fermyon-spin,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fermyon-spin";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "spinframework";
    repo = "spin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GeomzOM9ihGv4iPb95PEBXFre6oOsJfNKEef4MinBmg=";
  };

  cargoHash = "sha256-EIrbvZkWxsJTzrLDZuzmQ1UmwAbVZwTv/DhA+o0pUlY=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    installShellFiles
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    # Spin's build.rs attempts to run rustup to compile wasm test fixtures unless disabled
    BUILD_SPIN_EXAMPLES = "0";
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isMusl && stdenv.buildPlatform.isLinux) {
    # cc-rs erroneously passes -static to host C builds when CARGO_CFG_TARGET_FEATURE contains
    # crt-static. This supplies static glibc so libsql-sqlite3-parser can link its build-time rlemon tool.
    HOST_CFLAGS = "-L${buildPackages.glibc.static}/lib";

    # GCC's static libstdc++.a lacks PIC relocations on x86_64, which breaks rustc's default static-pie linking.
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      "-C relocation-model=static -C link-arg=-no-pie";
  };

  # Integration tests require network access, container engines, or wasm32-* compilation targets
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd spin \
      --bash <(COMPLETE=bash $out/bin/spin) \
      --fish <(COMPLETE=fish $out/bin/spin) \
      --zsh <(COMPLETE=zsh $out/bin/spin)
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = fermyon-spin;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Framework for building, deploying, and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://github.com/spinframework/spin";
    changelog = "https://github.com/spinframework/spin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "spin";
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = lib.platforms.unix;
  };
})
