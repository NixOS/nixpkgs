{
  lib,
  alsa-lib,
  dbus,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hullcaster";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gilcu3";
    repo = "hullcaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O3MBvadayZ6hryexPX/VN1NUZpHTg/JZATJRIOBgZCg=";
  };

  cargoHash = "sha256-/2prlOy3h+TtACJ9Oa7f9kYiaFGjFhoS8dO26w0fTrk=";

  buildInputs = [
    alsa-lib
    dbus
    openssl
    sqlite
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # work around error: Could not create filepath: /homeless-shelter/.local/share
  checkFlags = [
    "--skip=gpodder::tests::gpodder"
    "--skip=config::tests"
    "--skip=gpodder::tests"
  ];

  meta = {
    description = "Terminal-based podcast manager built in Rust";
    homepage = "https://github.com/gilcu3/hullcaster";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kiara ];
  };
})
