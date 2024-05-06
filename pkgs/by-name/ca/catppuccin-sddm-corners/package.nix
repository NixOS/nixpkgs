{ lib
, stdenvNoCC
, fetchFromGitHub
, libsForQt5
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm-corners";
  version = "unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "khaneliman";
    repo = "catppuccin-sddm-corners";
    rev = "ffaad5c8964b52ccd92a80dfd3a7931c8b68c446";
    hash = "sha256-CaCMrXlwt7JfSycB8WH3XCWUu+i7bPSfFv3duo7ZlZo=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  propagatedBuildInputs = with libsForQt5.qt5; [
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${libsForQt5.qt5.qtgraphicaleffects}  >> $out/nix-support/propagated-user-env-packages
    echo ${libsForQt5.qt5.qtquickcontrols2}  >> $out/nix-support/propagated-user-env-packages
    echo ${libsForQt5.qt5.qtsvg}  >> $out/nix-support/propagated-user-env-packages
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    cp -r catppuccin/ "$out/share/sddm/themes/catppuccin-sddm-corners"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Soothing pastel theme for SDDM based on corners theme.";
    homepage = "https://github.com/khaneliman/sddm-catppuccin-corners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
}
