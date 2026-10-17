{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
  nix-update-script,
  sassc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lavanda-gtk-theme";
  version = "2024-04-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Lavanda-gtk-theme";
    tag = finalAttrs.version;
    hash = "sha256-2ryhdgLHSNXdV9QesdB0rpXkr3i2vVqXWDDC5fNuL1c=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  # Replace with --no-gtk2 once merged:
  # https://github.com/vinceliuice/Lavanda-gtk-theme/pull/39
  patches = [ ./remove-gtk2.patch ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d "$out/share/themes"
    bash install.sh -d "$out/share/themes"

    jdupes --quiet --link-soft --recurse "$out/share"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lavanda gtk theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Lavanda-gtk-theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
