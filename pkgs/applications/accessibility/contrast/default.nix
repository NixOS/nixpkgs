{ stdenv
, fetchFromGitLab
, cairo
, dbus
, desktop-file-utils
, gettext
, glib
, gtk3
, libhandy_0
, meson
, ninja
, pango
, pkgconfig
, python3
, rustc
, rustPlatform
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "contrast";
  version = "0.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    sha256 = "0kk3mv7a6y258109xvgicmsi0lw0rcs00gfyivl5hdz7qh47iccy";
  };

  cargoSha256 = "0vi8nv4hkhsgqgz36xacwkk5cxirg6li44nbmk3x7vx7c64hzybq";

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
    glib # for glib-compile-resources
  ];

  buildInputs = [
    cairo
    dbus
    glib
    gtk3
    libhandy_0
    pango
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  meta = with stdenv.lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
  };
}

