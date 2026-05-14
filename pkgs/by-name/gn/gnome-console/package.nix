{
  lib,
  stdenv,
  fetchurl,
  appstream,
  gettext,
  gnome,
  libgtop,
  gtk4,
  libadwaita,
  pango,
  pcre2,
  vte-gtk4,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-console";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major finalAttrs.version}/gnome-console-${finalAttrs.version}.tar.xz";
    hash = "sha256-J7As6OiQ/49TyoXbeGsa41kD8LYyeBLwIk3AtUsQiNs=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libgtop
    gtk4
    libadwaita
    pango
    pcre2
    vte-gtk4
  ];

  preFixup = ''
    # FIXME: properly address https://github.com/NixOS/nixpkgs/pull/333911#issuecomment-2362710334
    # and https://gitlab.gnome.org/GNOME/console/-/commit/c81801c82f186f20
    gappsWrapperArgs+=(--set "TERM" "xterm-256color")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-console";
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.kgx;

  meta = {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zhaofengli ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    mainProgram = "kgx";
  };
})
