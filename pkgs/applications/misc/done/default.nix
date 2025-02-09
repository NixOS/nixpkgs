{ lib
, stdenv
, fetchFromGitHub
, cargo
, glib
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gdk-pixbuf
, gtk4
, libadwaita
, libsecret
, openssl
, sqlite
, darwin
, gettext
}:

stdenv.mkDerivation rec {
  pname = "done";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "done-devs";
    repo = "done";
    rev = "v${version}";
    hash = "sha256-97bWBayEyhCMjTxxxFVdO8V2pBZuVzss1Tp9/TnfDB0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "directories-4.0.1" = "sha256-4M8WstNq5I7UduIUZI9q1R9oazp7MDBRBRBHZv6iGWI=";
      "libset-0.1.2" = "sha256-+eA6pqafIYomXdlvwSzT/b/T4Je5HgPPmGL2M11VpMU=";
    };
  };

  nativeBuildInputs = [
    cargo
    glib
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libadwaita
    libsecret
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    GETTEXT_DIR = gettext;
    # Work around https://github.com/NixOS/nixpkgs/issues/166205.
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  meta = with lib; {
    description = "The ultimate task management solution for seamless organization and efficiency";
    homepage = "https://done.edfloreshz.dev/";
    changelog = "https://github.com/done-devs/done/blob/${src.rev}/CHANGES.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
