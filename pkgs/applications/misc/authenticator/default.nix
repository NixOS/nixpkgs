{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, appstream-glib
, clang
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, wrapGAppsHook4
, gdk-pixbuf
, glib
, gst_all_1
, gtk4
, libadwaita
, libclang
, openssl
, pipewire
, sqlite
, wayland
, zbar
}:

stdenv.mkDerivation rec {
  pname = "authenticator";
  version = "4.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    rev = version;
    hash = "sha256-fv7Np3haRCJABlJocKuu+1jevHYrdo+VyiQBpRmHs2g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8GddlDM1lU365GXdrKNhO331/y1p3Om5uZfVLy8TBGI=";
  };

  nativeBuildInputs = [
    appstream-glib
    clang
    desktop-file-utils
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
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; })
    gtk4
    libadwaita
    openssl
    pipewire
    sqlite
    wayland
    zbar
  ];

  LIBCLANG_PATH = "${lib.getLib libclang}/lib";

  meta = {
    description = "Two-factor authentication code generator for GNOME";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
