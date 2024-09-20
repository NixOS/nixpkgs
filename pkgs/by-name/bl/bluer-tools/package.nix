{
  lib,
  rustPlatform,
  fetchCrate,
  dbus,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluer-tools";
  version = "0.17.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ExsAXxFqScc4GSBc4claLKzcdgPn47mn310KcgkFVCo=";
  };

  cargoHash = "sha256-LW/0+ZqQ7MksyYzmySv3f7F6EYuFLfq9ebl5TYHfjFQ=";

  buildInputs = [
    dbus
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "A swiss army knife for GATT services, L2CAP and RFCOMM sockets on Linux";
    homepage = "https://crates.io/crates/bluer-tools";
    license = licenses.bsd2;
    maintainters = [ ];
    platforms = platforms.linux;
  };
}
