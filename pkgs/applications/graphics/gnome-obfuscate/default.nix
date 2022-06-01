{ stdenv
, lib
, fetchFromGitLab

, gettext
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook4

, appstream-glib
, desktop-file-utils
, glib
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "gnome-obfuscate";
  version = "0.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Obfuscate";
    rev = version;
    sha256 = "sha256-jEMOg2yHi6K57XhA/7hkwwvedmikoB8pGV3ka+jixq8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-P04BeidLXouPLzT/vsa4VC5AOENF0W4gqXqzdmRFhmE=";
  };

  nativeBuildInputs = [
    gettext
    glib
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream-glib
    desktop-file-utils
    glib
    gtk4
    libadwaita
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    description = "Censor private information";
    homepage = "https://gitlab.gnome.org/World/obfuscate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
