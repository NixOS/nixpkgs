{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  sassc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adw-gtk3";
  version = "5.10";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0OZk27b0kujzWtRX5uvelTMivL19g6sNB1IY6BsrO10=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  postPatch = ''
    chmod +x gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
    patchShebangs gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Theme from libadwaita ported to GTK-3";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ciferkey ];
  };
})
