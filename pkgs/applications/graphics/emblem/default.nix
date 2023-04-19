{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, appstream-glib
, desktop-file-utils
, glib
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gtk4
, libadwaita
, libxml2
, darwin
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "emblem";
    rev = version;
    sha256 = "sha256-sgo6rGwmybouTTBTPFrPJv8Wo9I6dcoT7sUVQGFUqkQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "librsvg-2.56.0" = "sha256-PIrec3nfeMo94bkYUrp6B7lie9O1RtiBdPMFUKKLtTQ=";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    description = "Generate project icons and avatars from a symbolic icon";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda foo-dogsquared ];
  };
}
