{
  fetchFromGitHub,
  glib,
  gtk3,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  lib,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "break-time";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo = "break-time";
    rev = "v${version}";
    sha256 = "sha256-q79JXaBwd/oKtJPvK2+72pY2YvaR3of2CMC8cF6wwQ8=";
  };

  cargoPatches = [
    # update Cargo.lock to work with openssl 3
    ./openssl3-support.patch
  ];

  cargoHash = "sha256-HthrPtIWvYLAQDpW12r250OWP7CF4SORlqFbxIq/Dzo=";

  nativeBuildInputs = [
    pkg-config
    python3 # needed for Rust xcb package
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    openssl
  ];

  meta = with lib; {
    description = "Break timer that forces you to take a break";
    mainProgram = "break-time";
    homepage = "https://github.com/cdepillabout/break-time";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
