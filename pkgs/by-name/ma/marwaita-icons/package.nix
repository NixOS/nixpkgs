{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, breeze-icons
, hicolor-icon-theme
, pantheon
}:

stdenvNoCC.mkDerivation rec {
  pname = "marwaita-icons";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-icons";
    rev = version;
    hash = "sha256-6NFCXj80VAoFX+i4By5IpbtJC4qL+sAzlLHUJjTQ/sI=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    hicolor-icon-theme
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Marwaita* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done

    runHook postInstall
  '';

  meta = {
    description = "Icon pack for linux";
    homepage = "https://github.com/darkomarko42/Marwaita-Icons";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
