{
  cxx-rs,
  fetchFromGitHub,
  lib,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "cxx-rs";
  version = "1.0.131";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cxx";
    rev = version;
    sha256 = "sha256-KQlbJvULdc94SM0sx6JtukZPpaX4Gojc6Qgr20V3/VI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

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
}
