{
  fetchFromGitHub,
  rustPlatform,
  lib,
  pkg-config,
  openssl,
  glib,
  atk,
  gtk3,
  libsoup,
  webkitgtk_4_1,
}:
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
  buildInputs = [
    openssl
    glib
    atk
    gtk3
    libsoup
    webkitgtk_4_1
  ];

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-RlYepSswszCV0/vboP3A6STyeAY8ddyrNzkmN0AHwRQ=";

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
  };
}
