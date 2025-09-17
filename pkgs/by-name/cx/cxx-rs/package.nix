{
  cxx-rs,
  fetchFromGitHub,
  lib,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cxx-rs";
  version = "1.0.175";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cxx";
    tag = finalAttrs.version;
    sha256 = "sha256-haAcBBI5ol+gcqKzasyHU43ewGA0L4FlL4o1QlJJukc=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [
    "--workspace"
    "--exclude=demo"
  ];

  postBuild = ''
    cargo doc --release
  '';

  cargoTestFlags = [ "--workspace" ];

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  postInstall = ''
    mkdir -p $doc
    cp -r ./target/doc/* $doc

    mkdir -p $dev/include/rust
    install -D -m 0644 ./include/cxx.h $dev/include/rust
  '';

  passthru.tests.version = testers.testVersion {
    package = cxx-rs;
    command = "cxxbridge --version";
  };

  meta = with lib; {
    description = "Safe FFI between Rust and C++";
    mainProgram = "cxxbridge";
    homepage = "https://github.com/dtolnay/cxx";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
})
