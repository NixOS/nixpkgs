{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fokus";
  version = "3.0.0";

  src = fetchFromGitLab {
    owner = "divinae";
    repo = "focus-plasmoid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xaiXeAjTOdCMfdltUgjaLZ7V0JYjl9DQYgyVI2y8A2Y=";
  };

  dontWrapQtApps = true;
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple pomodoro KDE Plasma plasmoid";
    homepage = "https://gitlab.com/divinae/focus-plasmoid";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ structix ];
    platforms = lib.platforms.linux;
  };
})
