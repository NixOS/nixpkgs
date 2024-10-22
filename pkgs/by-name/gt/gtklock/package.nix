{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  scdoc,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  pam,
  gtk-session-lock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock";
  # Must run nixpkgs-review between version changes
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e/JRJtQAyIvQhL5hSbY7I/f12Z9g2N0MAHQvX+aXz8Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    scdoc
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    pam
    gtk-session-lock
  ];

  strictDeps = true;

  meta = {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
      Otherwise you'll lock youself out of desktop and unable to authenticate.
    ''; # Following  nixpkgs/pkgs/applications/window-managers/sway/lock.nix
    homepage = "https://github.com/jovanlanik/gtklock";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dit7ya
      aleksana
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gtklock";
  };
})
