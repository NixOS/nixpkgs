{
  lib,
  buildGoModule,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "pictogrep";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tiagohierath";
    repo = "pictogrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sheiEParjSb+P6LY1/p32umNztB2mMaZ1ESzdzKmZmg=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    install -Dm644 assets/pictogrep.png \
      $out/share/icons/hicolor/512x512/apps/pictogrep.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "pictogrep";
      desktopName = "Pictogrep";
      comment = finalAttrs.meta.description;
      exec = "pictogrep";
      icon = "pictogrep";
      categories = [
        "Graphics"
        "Photography"
      ];
      keywords = [
        "images"
        "search"
        "storyboard"
      ];
    })
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Find local pictures using natural-language descriptions";
    homepage = "https://github.com/tiagohierath/pictogrep";
    changelog = "https://github.com/tiagohierath/pictogrep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tiagohierath ];
    mainProgram = "pictogrep";
    platforms = lib.platforms.linux;
  };
})
