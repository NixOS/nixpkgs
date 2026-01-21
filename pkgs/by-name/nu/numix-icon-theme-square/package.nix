{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  numix-icon-theme,
  hicolor-icon-theme,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme-square";
  version = "26.01.11";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-icon-theme-square";
    rev = version;
    sha256 = "sha256-fj7CaEUms7w+apaXW+6zMwqCwaLWlU2RJalGzFIaDNg=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    numix-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons

    for panel in $out/share/icons/*/*/panel; do
      ln -sf $(realpath ${numix-icon-theme}/share/icons/Numix/16/$(readlink $panel)) $panel
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Numix icon theme (square version)";
    homepage = "https://numixproject.github.io";
    license = lib.licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
