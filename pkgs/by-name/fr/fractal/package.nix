{
  stdenv,
  lib,
  fetchFromGitLab,
  nix-update-script,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  grass-sass,
  gtk4,
  gtksourceview5,
  lcms2,
  libadwaita,
  gst_all_1,
  desktop-file-utils,
  appstream-glib,
  openssl,
  pipewire,
  libshumate,
  wrapGAppsHook4,
  sqlite,
  xdg-desktop-portal,
  libseccomp,
  glycin-loaders,
}:

stdenv.mkDerivation rec {
  pname = "fractal";
  version = "10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    tag = version;
    hash = "sha256-dXmdoEBvHhOoICIDCpi2JTPo7j/kQzlv+Q/S/7LNyv0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-qRxJvlorS5S3Wj3HjfvvR2nM/ZWzefz4x791UeSXm0w=";
  };

  # Dirty approach to add patches after cargoSetupPostUnpackHook
  # We should eventually use a cargo vendor patch hook instead
  preConfigure = ''
    pushd ../$(stripHash $cargoDeps)/glycin-2.*
      patch -p3 < ${glycin-loaders.passthru.glycinPathsPatch}
    popd
  '';

  nativeBuildInputs = [
    glib
    grass-sass
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs =
    [
      glib
      gtk4
      gtksourceview5
      lcms2
      libadwaita
      openssl
      pipewire
      libshumate
      sqlite
      xdg-desktop-portal
      libseccomp
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
      gst-plugins-good
      gst-plugins-rs
    ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    changelog = "https://gitlab.gnome.org/World/fractal/-/releases/${version}";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    mainProgram = "fractal";
  };
}
