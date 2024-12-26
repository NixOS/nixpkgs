{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
}:

stdenvNoCC.mkDerivation {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2023-03-20";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "8481714cf9ed5148694f1916ceba8fe21e14937b";
    hash = "sha256-NO12ku8wnW/qMHKxi5TL/dqBxH0+cZbe+fU0iicb9JU=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/"{themes,icons}
    cp -a icons/* "$out/share/icons/"
    cp -a themes/* "$out/share/themes/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Everforest colour palette for GTK";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jn-sena ];
    platforms = platforms.unix;
  };
}
