{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "go-i18n";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "nicksnyder";
    repo = "go-i18n";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ag/8GBAwqkOyIVrdlaFYLxy9dgPOq7VbactrLmzxK7E=";
  };

  vendorHash = "sha256-HhSzcK5FdOL2itnO/9kPTExbq0ZvVbvkl+aFtbv//4c=";

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
