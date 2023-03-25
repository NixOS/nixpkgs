{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
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
, openssl
, pipewire
, sqlite
, wayland
, zbar
}:

stdenv.mkDerivation rec {
  pname = "authenticator";
  version = "4.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    rev = version;
    hash = "sha256-Nv4QE6gyh42Na/stAgTIapV8GQuUHCdL6IEO//J8dV8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-IS9jdr19VvgX6M1OqM6rjE8veujZcwBuOTuDm5mDXso=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
    bindgenHook
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

  # https://gitlab.gnome.org/World/Authenticator/-/issues/362
  preBuild = ''
    export BINDGEN_EXTRA_CLANG_ARGS="$BINDGEN_EXTRA_CLANG_ARGS -DPW_ENABLE_DEPRECATED"
  '';

  meta = {
    description = "Two-factor authentication code generator for GNOME";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ austinbutler ];
    platforms = lib.platforms.linux;
    # Fails to build on aarch64 with error
    # "a label can only be part of a statement and a declaration is not a statement"
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
