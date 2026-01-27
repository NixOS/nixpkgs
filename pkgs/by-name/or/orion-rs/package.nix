{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "orion-rs";
  version = "0.17.10";

  src = fetchFromGitHub {
    owner = "orion-rs";
    repo = "orion";
    rev = "${version}";
    hash = "sha256-pJxMpy9iIT1VJCJFcVCAUBNRUFC0ONUz3f2sWzkDBvU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoLock.lockFile = ./Cargo.lock;
  cargoBuildFlags = [ "--lib" ];

  installPhase = ''
    runHook preInstall

    local target_dir=target/${stdenv.hostPlatform.rust.rustcTarget}/release
    mkdir -p $out/lib
    cp -r $target_dir/deps $out/lib/

    cargo doc --no-deps --all-features
    mkdir -p $out/share/doc/${pname}
    cp -r target/doc/* $out/share/doc/${pname}/

    runHook postInstall
  '';

  postUnpack = ''
    cp ${./Cargo.lock} "$sourceRoot/Cargo.lock"
  '';

  doCheck = true;

  # Maintains default features (safe_api + std)
  # To enable experimental features add: cargoBuildFlags = [ "--features=experimental" ];

  meta = {
    description = "Usable, easy and safe pure-Rust cryptography library";
    homepage = "https://github.com/orion-rs/orion";
    changelog = "https://github.com/orion-rs/orion/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tanya1866 ];
  };
}
