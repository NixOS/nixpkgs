{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  gjs,
  glib-networking,
  gnome-bluetooth,
  gtk-layer-shell,
  libpulseaudio,
  libsoup_3,
  networkmanager,
  upower,
  typescript,
  wrapGAppsHook3,
  linux-pam,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ags";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "Aylur";
    repo = "ags";
    rev = "v${version}";
    hash = "sha256-ebnkUaee/pnfmw1KmOZj+MP1g5wA+8BT/TPKmn4Dkwc=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-ucWdADdMqAdLXQYKGOXHNRNM9bhjKX4vkMcQ8q/GZ20=";

  mesonFlags = [ (lib.mesonBool "build_types" true) ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gjs
    gobject-introspection
    typescript
    wrapGAppsHook3
  ];

  # Most of the build inputs here are basically needed for their typelibs.
  buildInputs = [
    gjs
    glib-networking
    gnome-bluetooth
    gtk-layer-shell
    libpulseaudio
    libsoup_3
    linux-pam
    networkmanager
    upower
  ];

  postPatch = ''
    chmod u+x ./post_install.sh && patchShebangs ./post_install.sh
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/Aylur/ags";
    description = "EWW-inspired widget system as a GJS library";
    changelog = "https://github.com/Aylur/ags/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      foo-dogsquared
      johnrtitor
    ];
    mainProgram = "ags";
    platforms = lib.platforms.linux;
  };
}
