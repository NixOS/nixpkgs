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
  version = "2.18";

  src = fetchFromGitHub {
    owner = "Picocrypt-NG";
    repo = "Picocrypt-NG";
    # Rewritten git history many times
    rev = "3261587f8b10471a6ed3c5ad132ada0f7c06e4cf";
    hash = "sha256-wjoYh6XWV4lJpSr9GQwPnlKGkbFH0YJOp1xVZJb5uOY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-pbldRarOQ44bE4FPUSHvk2Qk4WQ0zKU0Hd75E717mLI=";

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

  # git ls-files doesn't work as source is not a git repo
  checkFlags =
    let
      skippedTests = [
        "TestOldVersionLiteralsAreAllowlisted"
        "TestLinuxAppIdentityContract"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
    maintainers = with lib.maintainers; [
      tbutter
      ryand56
    ];
    mainProgram = "picocrypt-ng-gui";
  };
})
