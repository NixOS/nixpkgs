{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  inkscape,
  nix-update-script,
  python3,
  sassc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "numix-solarized-gtk-theme";
  version = "20230408";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "numix-solarized-gtk-theme";
    tag = finalAttrs.version;
    hash = "sha256-r5xCe8Ew+/SuCUaZ0yjlumORTy/y1VwbQQjQ6uEyGsY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    gdk-pixbuf
    glib
    inkscape
    python3
    sassc
  ];

  postPatch = ''
    patchShebangs scripts

    substituteInPlace Makefile \
      --replace-fail '$(DESTDIR)'/usr $out

    # The GTK2 theme needs gtk-engine-murrine, which is no longer packaged.
    # Removing the sources also keeps the preprocess step from generating its
    # gtkrc once per colour variant.
    rm -r src/gtk-2.0
    substituteInPlace scripts/utils.sh \
      --replace-fail 'assets gtk-2.0 metacity-1' 'assets metacity-1'
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    for theme in colors/*.colors; do
      theme="''${theme##*/}"
      make THEME="''${theme/.colors/}" install
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Solarized versions of the Numix GTK theme";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = "https://github.com/Ferdi265/numix-solarized-gtk-theme";
    downloadPage = "https://github.com/Ferdi265/numix-solarized-gtk-theme/releases";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
