{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,

  libxxf86vm,
  glfw,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "picocrypt-ng";
  version = "2.09";

  src = fetchFromGitHub {
    owner = "Picocrypt-NG";
    repo = "Picocrypt-NG";
    tag = finalAttrs.version;
    hash = "sha256-s+93NoJ1O6/Af33pUobSA0kAhpw7W0IdA9H6CVxShQY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-2c8Q7+97jSGo8lwWOYBg76K04+TFXG1DdQzVMR8G7ik=";

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
      libxxf86vm
    ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
    writableTmpDirAsHomeHook
  ];

  env.CGO_ENABLED = 1;

  postInstall = ''
    mv $out/bin/picocrypt $out/bin/picocrypt-ng-gui
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
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "picocrypt-ng-gui";
  };
})
