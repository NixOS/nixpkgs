{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kde-modernclock";
  version = "0.2.0-unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "Prayag2";
    repo = "kde_modernclock";
    rev = "5c86f0f23d2646be7e9872fc5e769bdce259af92";
    hash = "sha256-+FqTNdMbWXp27ZdfcgQvLE+yr2z6KxXbIIPpQTffEIE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapQtApps = true;

  nativeBuildInputs = [
    kdePackages.kpackage
    kdePackages.libplasma
  ];

  installPhase = ''
    runHook preInstall

    export QT_PLUGIN_PATH="${kdePackages.libplasma}/lib/qt-6/plugins:${kdePackages.kpackage}/lib/qt-6/plugins:$QT_PLUGIN_PATH"
    kpackagetool6 --type Plasma/Applet --install package --packageroot $out/share/plasma/plasmoids

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Modern clock widget for KDE Plasma desktop";
    homepage = "https://github.com/Prayag2/kde_modernclock";
    changelog = "https://github.com/Prayag2/kde_modernclock/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ subham-roy ];
    platforms = lib.platforms.linux;
  };
})
