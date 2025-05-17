{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  dart-sass,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adw-gtk3";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYaqSEnIYHHkY4L3UhFBkR3DehoB6QADhSGOP/9NKx8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    dart-sass
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Theme from libadwaita ported to GTK-3";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ciferkey
      Gliczy
    ];
  };
})
