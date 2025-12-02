{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "go-i18n";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "nicksnyder";
    repo = "go-i18n";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UrSECFbpCIg5avJ+f3LkJy/ncZFHa4q8sDqDIQ3YZJM=";
  };

  vendorHash = "sha256-4Kbdj2D6eJTjZtdsFMNES3AEZ0PEi01HS73uFNZsFMA=";

  subPackages = [
    "goi18n"
  ];

  env.CGO_ENABLED = 0;

  doCheck = true;

  meta = {
    changelog = "https://github.com/nicksnyder/go-i18n/releases/tag/${finalAttrs.src.tag}";
    description = "Translate your Go program into multiple languages";
    longDescription = ''
      goi18n is a tool that lets you extract messages from all your Go source files,
      generates new language files.
    '';
    homepage = "https://github.com/nicksnyder/go-i18n";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ videl ];
    mainProgram = "goi18n";
  };
})
