{ stdenv
, lib
, fetchFromGitLab
, cairo
, desktop-file-utils
, gettext
, glib
, gtk4
, libadwaita
, meson
, ninja
, pango
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "contrast";
  version = "0.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    sha256 = "cypSbqLwSmauOoWOuppWpF3hvrxiqmkLspxAWzvlUC0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-W4FyqwJpimf0isQRCq9TegpTQPQfsumx40AFQCFG5VQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook4
    glib # for glib-compile-resources
  ];

  buildInputs = [
    cairo
    glib
    gtk4
    libadwaita
    pango
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
    # https://gitlab.gnome.org/World/design/contrast/-/merge_requests/23
    substituteInPlace build-aux/meson_post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  meta = with lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}

