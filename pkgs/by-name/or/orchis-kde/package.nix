{
  fetchFromGitHub,
  jdupes,
  kdePackages,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "orchis-kde";
  version = "0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "b2a96919eee40264e79db402b915f926436100ad";
    hash = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
  };

  outputs = [
    "out"
    "sddm"
  ];

  nativeBuildInputs = [
    jdupes
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    # Do installation
    mkdir -p $out/share/aurorae/themes
    cp -r aurorae/* $out/share/aurorae/themes/

    mkdir -p $out/share/color-schemes
    cp -r color-schemes/* $out/share/color-schemes/

    mkdir -p $out/share/Kvantum
    cp -r Kvantum/* $out/share/Kvantum/

    mkdir -p $out/share/plasma
    cp -r plasma/* $out/share/plasma/

    mkdir -p $out/share/wallpapers
    cp -r wallpaper/* $out/share/wallpapers

    mkdir -p $sddm/share/sddm/themes
    cp -r sddm/6.0/Orchis $sddm/share/sddm/themes/

    # Replace duplicated files with symlinks
    jdupes --quiet --link-soft --recurse $out/share
    jdupes --quiet --link-soft --recurse $sddm/share

    runHook postInstall
  '';

  postFixup = ''
    # Propagate SDDM theme dependencies to user env
    mkdir -p $sddm/nix-support

    printWords ${kdePackages.breeze-icons} ${kdePackages.libplasma} ${kdePackages.plasma-workspace} \
      >> $sddm/nix-support/propagated-user-env-packages
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Materia Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Orchis-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.starryreverie ];
  };
}
