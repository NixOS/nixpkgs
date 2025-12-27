{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  sassc,
}:

stdenvNoCC.mkDerivation {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "9b8be4d6648ae9eaae3dd550105081f8c9054825";
    hash = "sha256-XHO6NoXJwwZ8gBzZV/hJnVq5BvkEKYWvqLBQT00dGdE=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
    sassc
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/"{themes,icons}
    cp -a icons/* "$out/share/icons/"
    bash themes/install.sh -d "$out/share/themes" -c dark -n Everforest
    bash themes/install.sh -d "$out/share/themes" -c light -n Everforest
    runHook postInstall
  '';
  # Use either "Everforest-Dark" or "Everforest-Light" for the theme name.

  dontFixup = true;

  meta = {
    description = "Everforest colour palette for GTK";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jn-sena ];
    platforms = lib.platforms.unix;
  };
}
