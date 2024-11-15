{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "railsy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mmkaram";
    repo = "railsy";
    rev = "v${version}";
    hash = "sha256-rmU5/j2HpErcv+bSeskBSPb/CXXmPPf7cJq9+zAfnc0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  meta = with lib; {
    description = "Temporary email client in Rust";
    homepage = "https://mmkaram.github.io/railsy.html";
    license = licenses.mit;
    maintainers = with maintainers; [ mmkaram ];
    platforms = platforms.unix;
  };
}
