{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation {
  pname = "kuyen-icons";
  version = "2.0"; # https://www.opendesktop.org/p/1290492/

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "kuyen-icons";
    rev = "7d4fdecf7121ae6077e5d22501a13ba5eb54a9f6";
    hash = "sha256-28AAcjg8f0FWwbYeYOMX5OJX2eYL6/a3dgu1HlkW2ZU=";
  };

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/kuyen-icons
    cp -r * $out/share/icons/kuyen-icons

    # Remove broken symlinks
    find $out/share/icons/kuyen-icons -xtype l -delete
    runHook postInstall
  '';

  meta = {
    description = "Colourful flat theme designed for Plasma desktop";
    homepage = "https://gitlab.com/froodo_alexis/kuyen-icons";
    license = lib.licenses.cc-by-nc-sa-30;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ iamanaws ];
  };
}
