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
  gtk4,
  gtksourceview5,
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
  version = "9";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    rev = "refs/tags/${version}";
    hash = "sha256-3UI727LUYw7wUKbGRCtgpkF9NNw4XuZ3tl3KV3Ku9r4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.7.1" = "sha256-AmODDuNLpI6gXuu+oPl3MqcOnywqR8lqJ0bVOIiz02E=";
      "ruma-0.10.1" = "sha256-6U2LKMYyY7SLOh2jJcVuDBsfcidNoia1XU+JsmhMHGY=";
    };
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
