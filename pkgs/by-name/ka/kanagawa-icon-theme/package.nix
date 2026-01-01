{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-icon-theme";
  version = "0-unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "35936a1e3bbd329339991b29725fc1f67f192c1e";
    hash = "sha256-BZRmjVas8q6zsYbXFk4bCk5Ec/3liy9PQ8fqFGHAXe0=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a icons/* $out/share/icons
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache -f $theme
    done

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Icon theme for the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iynaix ];
=======
  meta = with lib; {
    description = "Icon theme for the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iynaix ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = gtk3.meta.platforms;
  };
}
