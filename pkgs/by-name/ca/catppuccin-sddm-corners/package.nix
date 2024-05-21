{ lib
, stdenvNoCC
, fetchFromGitHub
, libsForQt5
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm-corners";
  version = "0-unstable-2024-05-07";

  src = fetchFromGitHub {
    owner = "khaneliman";
    repo = "catppuccin-sddm-corners";
    rev = "aca5af5ce0c9dff56e947938697dec40ea101e3e";
    hash = "sha256-xtcNcjNQSG7SwlNw/EkAU93wFaku+cE1/r6c8c4FrBg=";
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
