{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  qt6,
  quickshell,
  grim,
  imagemagick,
  wl-clipboard,
  libnotify,
  satty,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprquickframe";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Ronin-CK";
    repo = "HyprQuickFrame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vCS5TwGoFi+zArrLu8IfnGhwTFeGGdCys6LsP+ySnDg=";
  };

  nativeBuildInputs = [
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qt5compat
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hyprquickframe
    cp -r . $out/share/hyprquickframe/

    mkdir -p $out/bin
    makeWrapper ${quickshell}/bin/quickshell $out/bin/hyprquickframe \
      --prefix PATH : ${
        lib.makeBinPath [
          quickshell
          grim
          imagemagick
          wl-clipboard
          libnotify
          satty
        ]
      } \
      --add-flags "-c $out/share/hyprquickframe -n"

    runHook postInstall
  '';

  meta = {
    description = "Quickshell-based screenshot utility for Hyprland";
    homepage = "https://github.com/Ronin-CK/HyprQuickFrame";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hyprquickframe";
  };
})
