{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
  papirus-folders,
  color ? null,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "papirus-icon-theme";
  version = "20250501";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    tag = finalAttrs.version;
    hash = "sha256-KbUjHmNzaj7XKj+MOsPM6zh2JI+HfwuXvItUVAZAClk=";
  };

  nativeBuildInputs = [
    gtk3
    papirus-folders
  ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  # breeze-icons propagates qtbase
  dontWrapQtApps = true;

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv Papirus* $out/share/icons

    for theme in $out/share/icons/*; do
      ${lib.optionalString (color != null) "papirus-folders -t $theme -o -C ${color}"}
      gtk-update-icon-cache --force $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Pixel perfect icon theme for Linux";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = lib.licenses.gpl3Only;
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      romildo
      moni
    ];
  };
})
