{
  cxx-rs,
  fetchFromGitHub,
  lib,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "cxx-rs";
  version = "1.0.158";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cxx";
    rev = version;
    sha256 = "sha256-cihF9VWAvqQxwvRJRfDIVxf56ajgFaOEv0vBvSQd2WY=";
  };

  cargoHash = "sha256-JxSWct7lx1oDVQ4QnqC9qRJg86XNppn+s4n5ZX0JXIQ=";

  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

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
}
