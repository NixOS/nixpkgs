{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "drawy";
  version = "1.0.0-alpha-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "Prayag2";
    repo = "drawy";
    rev = "ca02b66a9615c45c78f2e29839a40c1e5bf8f71c";
    hash = "sha256-PzIeyhF/1wKD6JyybNRzruuxzSKJZvIq+L7X0rrcQUY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = with qt6; [
    qtbase
    qttools
  ];

  postInstall = ''
    for size in 16 32 256 512; do
      install -D --mode=644 \
        "$src"/assets/logo-$size.png \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/drawy.png"
    done

    install -D --mode=644 \
      "$src"/assets/logo.svg \
      "$out"/share/icons/hicolor/scalable/apps/drawy.svg

    install -D --mode=644 \
      "$src"/deploy/appimage/AppDir/usr/share/applications/drawy.desktop \
      --target-directory="$out"/share/applications
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Handy and infinite brainstorming tool";
    homepage = "https://github.com/Prayag2/drawy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      yiyu
      quarterstar
    ];
    mainProgram = "drawy";
    platforms = lib.platforms.all;
  };
}
