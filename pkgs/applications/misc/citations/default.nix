{ appstream-glib
, cargo
, citations
, clippy
, darwin
, desktop-file-utils
, fetchFromGitLab
, gettext
, glib
, gtk4
, gtksourceview5
, lib
, libadwaita
, meson
, ninja
, pkg-config
, poppler
, rustPlatform
, rustc
, stdenv
, testers
, wrapGAppsHook4
}:
stdenv.mkDerivation rec {
  pname = "citations";
  version = "0.5.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "citations";
    rev = version;
    hash = "sha256-QofsVqulFMiyYKci2vHdQAUJoIIgnPyTRizoBDvYG+g=";
  };

  patches = [
    ./Cargo.lock.patch # Fix: ERROR: The Cargo.lock contains git dependencies (nom-bibtex-0.4.0)
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-CeXHGFPNb1ANevFRfMf6YU4s5QWvmBaL3w3e0oF8bKo=";
  };

  nativeBuildInputs = [
    appstream-glib
    cargo
    clippy
    desktop-file-utils
    gettext
    glib
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    libadwaita
    poppler
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  doCheck = false; # ture; -> error: no such command: `clippy` View all installed commands with `cargo --list`

  passthru.tests.version = testers.testVersion {
    package = citations;
    command = "citations --help";
  };

  meta = with lib; {
    description = "Manage your bibliographies using the BibTeX format";
    homepage = "https://apps.gnome.org/app/org.gnome.World.Citations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    platforms = platforms.unix;
  };
}
