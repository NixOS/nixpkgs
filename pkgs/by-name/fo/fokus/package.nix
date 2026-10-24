{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fokus";
  version = "3.2.0";

  src = fetchFromGitLab {
    owner = "divinae";
    repo = "focus-plasmoid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t8C0zLyUL2Trb7WzTm5XXgqrjsZmZ8Cxf/5C8pHXYSw=";
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

  # nix-update-script would stick on v2.3.3 as this is the only Gitlab Release upstream. Releases are marked with Git tags.
  passthru.updateScript = gitUpdater {
    url = "https://gitlab.com/divinae/focus-plasmoid.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Simple pomodoro KDE Plasma plasmoid";
    homepage = "https://gitlab.com/divinae/focus-plasmoid";
    changelog = "https://gitlab.com/divinae/focus-plasmoid/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ structix ];
    platforms = lib.platforms.linux;
  };
})
