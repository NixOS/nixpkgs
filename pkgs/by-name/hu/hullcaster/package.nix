{
  lib,
  alsa-lib,
  dbus,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hullcaster";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gilcu3";
    repo = "hullcaster";
    tag = "v${version}";
    hash = "sha256-BR3klwy6vm6nJ38sgS/PGPQ19n0GJq6eQE97lHmg+kQ=";
  };

  cargoHash = "sha256-TZmRObtkwrHRy/I6hhacbHUWiajKDLnHafLWIwVM15o=";

  buildInputs = [
    alsa-lib
    dbus
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # work around error: Could not create filepath: /homeless-shelter/.local/share
  checkFlags = [
    "--skip gpodder::tests::gpodder"
  ];

  meta = {
    description = "Terminal-based podcast manager built in Rust";
    homepage = "https://github.com/gilcu3/hullcaster";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kiara ];
  };
}
