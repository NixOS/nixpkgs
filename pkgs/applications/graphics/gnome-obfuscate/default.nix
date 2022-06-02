{ stdenv
, lib
, fetchFromGitLab

, gettext
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook

, appstream-glib
, desktop-file-utils
, glib
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "gnome-obfuscate";
  version = "0.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Obfuscate";
    rev = version;
    sha256 = "sha256-P8Y2Eizn1BMZXuFjGMXF/3oAUzI8ZNTrnbLyU+V6uk4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-5MzWz5NH2sViIfaP8xOQLreEal5TYkji11VaUgieT3U=";
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
    wrapGAppsHook
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
