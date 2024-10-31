{ fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, glib, atk, gtk3, libsoup, webkitgtk_4_1 }:
rustPlatform.buildRustPackage {
  pname = "snx-rs";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    rev = "v2.2.3";
    hash = "sha256-tBl67uDeYVmVBwi8NQVclfFQ0Sj1dl+hR8Jct1iE2LI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl glib atk gtk3 libsoup webkitgtk_4_1 ];

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "isakmp-0.1.0" = "sha256-6v5xhkt9iaQg3Eh8S1tXW55oLv4YFDYvY0cfsepMuIM=";
    };
  };

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
  };
}
