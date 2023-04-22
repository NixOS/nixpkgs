{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BvSDFWmIQ55kbZtWybemZXT7lSDwxSCpPAsqwElZOBM=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "podman-api-0.10.0-dev" = "sha256-6xpPdssfgXY5sDyZOzApaZPjzDLqq734UEl9FTkZyQQ=";
      "vte4-0.5.0" = "sha256-7yXIcvMNAAeyK57O5l42ndBI+Ij55KFwClhBeLM5Zlo=";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
