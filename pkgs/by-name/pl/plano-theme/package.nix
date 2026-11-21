{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  fetchpatch2,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plano-theme";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "plano-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-slGr2nsdKng6zaVDeXWFAWKIxZbcnOLU6RH6wM0293E=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  # Backport the gtk2 option, which is merged upstream but not in a release.
  patches = [
    (fetchpatch2 {
      url = "https://github.com/lassekongo83/plano-theme/commit/17c1fbc69b7dde3859623f18d429fe0c57942f9f.patch";
      hash = "sha256-yy54gsgCBV03qC9aPplbgMVEW1DoR9wa+09JhTCrvvM=";
    })
  ];

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  mesonFlags = [ (lib.mesonBool "gtk2" false) ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flat theme for GNOME and Xfce";
    homepage = "https://github.com/lassekongo83/plano-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
