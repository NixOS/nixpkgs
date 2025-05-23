{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mkbrr";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "mkbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v5MkbsXbS37axZTrp7YTNCU5/uqVW1vnJu+F5hxk3bI=";
  };

  vendorHash = "sha256-G8WM5x99UZfAZUkE5W37Ogx/OKk8JypPzGBrIuBOFNo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.buildTime=unknown"
  ];

  doCheck = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Tool to create, modify and inspect torrent files";
    homepage = "https://github.com/autobrr/mkbrr";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "mkbrr";
  };
})
