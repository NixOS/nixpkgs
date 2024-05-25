{ fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, glib, atk, gtk3, libsoup, webkitgtk_4_1 }:
rustPlatform.buildRustPackage {
  pname = "snx-rs";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    rev = "v2.2.0";
    hash = "sha256-9aBJM20+G1U2NuJXBmax50o3M/lwRpLeqdcHCA28iAw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl glib atk gtk3 libsoup webkitgtk_4_1 ];

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "isakmp-0.1.0" = "sha256-Gk0/tyIQ62kH6ZSW6ov8SMVR2UBEWkz8HfqeWjSXmlY=";
    };
  };

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agplv3;
    maintainers = [ lib.maintainers.lheckemann ];
  };
}
