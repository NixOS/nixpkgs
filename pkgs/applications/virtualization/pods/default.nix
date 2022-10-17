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
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.0.0-beta.6";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ndsxa4d4lB1kZtRoLmAs/3e93qoKlS1YjB1GK9xby/A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-qgR7wVXGJyAYCh9B9uJ63njXjiZa4BswfFMBhBpvKoM=";
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
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
