{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
}:

stdenvNoCC.mkDerivation {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "930a5dc57f7a06e8c6538d531544e41c56dbb27a";
    hash = "sha256-mlJE7gVElWUjJIZnAL5ztchphmaU82llol+YdKqnSxg=";
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
