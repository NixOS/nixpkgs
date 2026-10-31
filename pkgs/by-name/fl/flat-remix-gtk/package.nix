{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flat-remix-gtk";
  version = "20240730";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "flat-remix-gtk";
    tag = finalAttrs.version;
    hash = "sha256-EWe84bLG14RkCNbHp0S5FbUQ5/Ye/KbCk3gPTsGg9oQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  # Replace with EXCLUDE=gtk-2.0 once merged:
  # https://github.com/daniruiz/flat-remix-gtk/pull/174
  patches = [ ./remove-gtk2.patch ];

  dontConfigure = true;
  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK application theme inspired by material design";
    homepage = "https://drasite.com/flat-remix-gtk";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
