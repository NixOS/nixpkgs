{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "go-i18n";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "nicksnyder";
    repo = "go-i18n";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IOswveIccIu7AQWdnPjSlyDlE8W24dMa8AAKbVN1W1k=";
  };

  vendorHash = "sha256-Dyktd6BWk6nGmc9WArMYNi3/tN6Z2+zvCxZ8Gsd9SwM=";

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
