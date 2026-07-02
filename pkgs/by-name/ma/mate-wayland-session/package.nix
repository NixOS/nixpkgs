{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  mate-polkit,
  mate-notification-daemon,
  mate-settings-daemon,
  wayfire,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mate-wayland-session";
  version = "1.28.5";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-wayland-session";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YWuBAzsLrvnwGgXbcDzIZtQIscIl37Y3wIRCOKidtYo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
  ];

  postPatch = ''
    substituteInPlace session/mate-wayland-components.sh \
      --replace-fail "polkit-mate-authentication-agent-1" "${mate-polkit}/libexec/polkit-mate-authentication-agent-1" \
      --replace-fail "mate-notification-daemon" "${mate-notification-daemon}/libexec/mate-notification-daemon" \
      --replace-fail "mate-settings-daemon" "${mate-settings-daemon}/libexec/mate-settings-daemon"

    substituteInPlace session/mate-wayland.sh \
      --replace-fail "/usr/share/doc/wayfire/examples/wayfire.ini" "${wayfire.src}/wayfire.ini"
  '';

  passthru = {
    providedSessions = [ "MATE" ];
    updateScript = gitUpdater {
      rev-prefix = "v";
      odd-unstable = true;
    };
  };

  meta = {
    description = "Wayland session using Wayfire for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
