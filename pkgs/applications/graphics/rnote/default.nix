{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, appstream-glib
, desktop-file-utils
, gio-sharp
, glib
, gstreamer
, gtk4
, libadwaita
, libxml2
, meson
, ninja
, pkg-config
, poppler
, python3
, rustPlatform
, shared-mime-info
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.5.1-hotfix-1";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Oq/RKeKICyImSPr4GSNjPXZWtuRQ7+9nRfl9MmC+UYI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-gdVy+7xSQVkI84Ta6KLOLR9UUsDoD2Cd0cuNU+OXf2M=";
  };

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    desktop-file-utils # For update-desktop-database
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    gio-sharp
    glib
    gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ];

  postPatch = ''
    pushd build-aux
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    substituteInPlace meson_post_install.py --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda yrd ];
    platforms = platforms.linux;
  };
}
