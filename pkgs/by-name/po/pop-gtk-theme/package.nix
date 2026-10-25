{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  glib,
  meson,
  ninja,
  nix-update-script,
  python3,
  sassc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pop-gtk-theme";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I8yujsRiLbDDNrCeWbOHPE+kfypH39DPNkYaRC3WA+s=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    glib # for glib-compile-resources
    meson
    ninja
    python3
    sassc
  ];

  postPatch = ''
    patchShebangs gnome-shell

    # The GTK2 theme needs gtk-engine-murrine, which is no longer packaged.
    # Replace with -Dgtk2=false once merged:
    # https://github.com/pop-os/gtk-theme/pull/610
    substituteInPlace gtk/src/dark/meson.build gtk/src/light/meson.build \
      --replace-fail "subdir('gtk-2.0')" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System76 Pop GTK theme";
    homepage = "https://github.com/pop-os/gtk-theme";
    license =
      with lib.licenses;
      AND [
        gpl3Plus # most of the theme
        lgpl21Plus # the GTK3 stylesheets, derived from upstream Adwaita
        cc-by-sa-40 # the SVG assets and the sound theme
      ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
