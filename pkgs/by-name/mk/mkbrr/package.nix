{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mkbrr";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "mkbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sq6J3c3ksVzg3RtEq2LxJLi1CDv8VaKYLiOYxztMV7w=";
  };

  vendorHash = "sha256-gZKPYItq6bmjdLBCuWdsdISlXvROmgXzRrD1qG4aQZk=";

  # From v1.23.0, a separate Go module (GUI) was introduced into the repo. Build only the cli tool.
  subPackages = [ "." ];

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
    changelog = "https://github.com/autobrr/mkbrr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "mkbrr";
  };
})
