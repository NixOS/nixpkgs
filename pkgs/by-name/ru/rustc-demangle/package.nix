{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustc-demangle";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustc-demangle";
    tag = "rustc-demangle-v${version}";
    hash = "sha256-4/x3kUIKi3xnDRznr+6xmPeWHmhlpbuwSNH3Ej6+Ifc=";
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
    maintainers = with lib.maintainers; [ _1000teslas ];
  };
}
