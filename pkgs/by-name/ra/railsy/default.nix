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
    rev = "ref/tags/v${version}";
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

  meta =  {
    description = "Temporary email client in Rust";
    homepage = "https://mmkaram.github.io/railsy.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lib.maintainers.mmkaram ];
    platforms = lib.platforms.unix;
  };
}
