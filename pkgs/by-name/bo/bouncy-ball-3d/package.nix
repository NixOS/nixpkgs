{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bouncy-ball-3d";
  version = "1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "hein";
    repo = "bouncy-ball-3d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cg09baVO1ycGZIzx7SpIEYvtrW0LbGYMXnOaQZmDy34=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = with kdePackages; [
    kpackage
  ];

  installPhase = ''
    runHook preInstall

    export QT_PLUGIN_PATH="${kdePackages.libplasma}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
    kpackagetool6 --type Plasma/Applet --install package --packageroot $out/share/plasma/plasmoids

    runHook postInstall
  '';

  meta = {
    description = "Glossy, squishy 3D ball for the Plasma desktop";
    homepage = "https://store.kde.org/p/2373730/";
    changelog = "https://invent.kde.org/hein/bouncy-ball-3d/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    platforms = lib.platforms.linux;
  };
})
