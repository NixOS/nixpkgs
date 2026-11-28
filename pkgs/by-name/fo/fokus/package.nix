{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fokus";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "divinae";
    repo = "focus-plasmoid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2f8eGgLXx/VTQp2E4btqzCFavlldKSirrnLccC5jsys=";
  };

  dontWrapQtApps = true;

  # No build is needed, as this is a plasmoid with QML files only.
  dontBuild = true;

  postPatch = ''
    substituteInPlace package/contents/config/main.xml package/contents/ui/configNotifications.qml \
         --replace-fail "/usr/share/sounds" "${kdePackages.ocean-sound-theme}/share/sounds"

    substituteInPlace package/contents/ui/Sfx.qml \
         --replace-fail 'import QtMultimedia' 'import "file://${kdePackages.qtmultimedia}/lib/qt-6/qml/QtMultimedia"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids/com.dv.fokus
    cp -r package/* $out/share/plasma/plasmoids/com.dv.fokus/

    runHook postInstall
  '';

  # Releases are marked with Git tags, there are no GitHub Releases upstream.
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Simple pomodoro KDE Plasma plasmoid";
    homepage = "https://github.com/divinae/focus-plasmoid";
    changelog = "https://github.com/divinae/focus-plasmoid/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ structix ];
    platforms = lib.platforms.linux;
  };
})
