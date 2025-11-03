{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  nix-update-script,
  testers,
  sozu,
}:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = "sozu";
    rev = version;
    hash = "sha256-yODApjpcHl9wmf+6TEVzXTme8e68b3Ee1y64D/u7NW8=";
  };

  cargoHash = "sha256-HADNumewYIejVPHXknGayrK4hZ5hBCk0rTFQ/xeG3Mo=";

  nativeBuildInputs = [ protobuf ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sozu;
      command = "sozu --version";
      version = "${version}";
    };
  };

  meta = {
    description = "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      gaelreyrol
    ];
    mainProgram = "sozu";
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.hostPlatform.isx86_64;
  };
}
