{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustc-demangle";
  version = "0.1.28";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustc-demangle";
    tag = "rustc-demangle-v${finalAttrs.version}";
    hash = "sha256-Fu9Lvg2QRMQSBWXLZMIRBUoX2aJB4HirfnMe2v9x6Yc=";
  };

  cargoLock = {
    # generated using `cargo generate-lockfile` since repo is missing lockfile
    lockFile = ./Cargo.lock;
  };

  cargoBuildFlags = [
    "-p"
    "rustc-demangle-capi"
  ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/librustc_demangle${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    cp -R crates/capi/include $out
  '';

  meta = {
    description = "Rust symbol demangling";
    homepage = "https://github.com/rust-lang/rustc-demangle";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sledgehammervampire ];
  };
})
