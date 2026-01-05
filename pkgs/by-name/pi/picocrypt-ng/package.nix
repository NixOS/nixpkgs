{
  lib,
  buildGoModule,
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

buildGoModule (finalAttrs: {
  pname = "picocrypt-ng";
  version = "2.00";

  src = fetchFromGitHub {
    owner = "Picocrypt-NG";
    repo = "Picocrypt-NG";
    tag = finalAttrs.version;
    hash = "sha256-+Ecvy4h0aC9Gra9BcN8L/vgpnflq6W7KcnYCVr8uaQQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-0fEy/YuZa7dENfL3y+NN4SLWYwOLmXqHHJEiU37AkX4=";

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
    mv $out/bin/Picocrypt $out/bin/picocrypt-ng-gui
    install -Dm644 $src/images/key.svg $out/share/icons/hicolor/scalable/apps/picocrypt-ng.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Picocrypt-NG";
      exec = "picocrypt-ng-gui";
      icon = "picocrypt-ng";
      comment = finalAttrs.meta.description;
      desktopName = "Picocrypt-NG";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Very small, very simple, yet very secure encryption tool";
    homepage = "https://github.com/Picocrypt-NG/Picocrypt-NG";
    changelog = "https://github.com/Picocrypt-NG/Picocrypt-NG/blob/${finalAttrs.version}/Changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "picocrypt-ng-gui";
  };
})
