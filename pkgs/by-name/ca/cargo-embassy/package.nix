{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage {
  pname = "cargo-embassy";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "adinack";
    repo = "cargo-embassy";
    # 0.3.4 with cargo.lock. Switch back
    # to tag = when next version released
    rev = "989a406387ebda89acd943c57e207d78eba600c1";
    hash = "sha256-C8eFQFHYIj2P+zPOKLVBNX97UDVbbcdjbqh5n53ktCU=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  cargoHash = "sha256-iLGoc6CKZGlq9bw1sL0jCVm9lGa0i/BXiseU1USGjfQ=";

  meta = {
    description = "Command line tool for creating Embassy projects";
    homepage = "https://github.com/adinack/cargo-embassy";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.samw ];
    platforms = lib.platforms.unix;
    mainProgram = "cargo-embassy";
  };
}
