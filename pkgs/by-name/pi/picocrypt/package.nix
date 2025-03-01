{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,

  xorg,
  glfw,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
}:

buildGo124Module rec {
  pname = "picocrypt";
  version = "1.47";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "Picocrypt";
    tag = version;
    hash = "sha256-O/n9dJz8cdJwldOXnsG8W8OZU5WeSmNys746HxRHvdc=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-9xB0D5Og/eiWUZGMog6lBoze4GrdvBOtNAKcMc3AdIE=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs =
    # Depends on a vendored, patched GLFW.
    glfw.buildInputs or [ ]
    ++ glfw.propagatedBuildInputs or [ ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      gtk3
      xorg.libXxf86vm
    ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  env.CGO_ENABLED = 1;

  postInstall = ''
    mv $out/bin/Picocrypt $out/bin/picocrypt-gui
    install -Dm644 $src/images/key.svg $out/share/icons/hicolor/scalable/apps/picocrypt.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Picocrypt";
      exec = "picocrypt-gui";
      icon = "picocrypt";
      comment = meta.description;
      desktopName = "Picocrypt";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Very small, very simple, yet very secure encryption tool, written in Go";
    homepage = "https://github.com/Picocrypt/Picocrypt";
    changelog = "https://github.com/Picocrypt/Picocrypt/blob/${version}/Changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "picocrypt-gui";
  };
}
