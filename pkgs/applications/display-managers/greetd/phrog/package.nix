{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nixosTests,
  makeDesktopItem,
  installShellFiles,

  dbus,
  polkit,

  phosh,
  pkg-config,
  gobject-introspection,
  gdk-pixbuf,
  atkmm,
  gtk3,
  gtk4,
  libhandy,
  glib,
  wrapGAppsHook4,
  gsettings-desktop-schemas,
  gnome-settings-daemon,
  gnome-session,
  accountsservice,
  squeekboard,
  calls,
}:
let
  oskItem = makeDesktopItem {
    name = "sm.puri.OSK0";
    desktopName = "On-screen keyboard";
    exec = "${squeekboard}/bin/squeekboard";
    categories = [
      "GNOME"
      "Core"
    ];
    onlyShowIn = [ "GNOME" ];
    noDisplay = true;
    extraConfig = {
      X-GNOME-Autostart-Phase = "Panel";
      X-GNOME-Provides = "inputmethod";
      X-GNOME-Autostart-Notify = "true";
      X-GNOME-AutoRestart = "true";
    };
  };
in
rustPlatform.buildRustPackage rec {
  pname = "phrog";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "samcday";
    repo = "phrog";
    rev = version;
    hash = "sha256-dhoBGlg/UyvO60Kd8BMnVWxDXVSiM+fUnA9ef/oOcMA=";
  };

  cargoHash = "sha256-Obz/pnNmMbZjkwerNxqu3/O9pYfaCjYJHOvSF72VEwM=";

  doCheck = false; # There's no access to dbus daemon anyway, so we can't run `test_accent_colours`. The unit tests also require GNOME and a Wayland session.

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    installShellFiles
  ];

  buildInputs = [
    phosh
    gdk-pixbuf
    atkmm
    gtk4
    gtk3
    libhandy
    gsettings-desktop-schemas
    gnome-settings-daemon
    gnome-session
    glib
    accountsservice
    squeekboard
    oskItem
    calls
    polkit
  ];

  # Phrog wants to access $XDG_HOME. This is not allowed.
  # It also has hardcoded paths for sessions. This is also not allowed.

  patches = [
    ./0001-nixos-phrog-contain-schema-dir-within-drv.patch
  ];

  cargoPatches = [
    ./0001-nixos-Use-XDG_DATA_DIRS-instead-of-hardcoded-paths-t.patch
  ];

  preConfigure = ''
    mkdir $out/share/glib-2.0/schemas/ -p

    substituteInPlace build.rs \
    --replace-fail "{interp}" "$out/share/glib-2.0/schemas" \
  '';

  postFixup = ''
    mkdir $out/share/gnome-session/sessions -p
    mkdir $out/share/wayland-sessions -p

    cp data/phrog.session $out/share/gnome-session/sessions/phrog.session
    cp data/mobi.phosh.Phrog.desktop $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "mobi.phosh.Phrog" ];
    tests.phosh = nixosTests.phosh;
  };

  meta = {
    description = "A greeter that works on mobile devices and also other kinds of computers";
    homepage = "https://github.com/samcday/phrog";
    changelog = "https://github.com/samcday/phrog/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hustlerone ];
    platforms = lib.platforms.linux;
    mainProgram = "phrog";
  };
}
