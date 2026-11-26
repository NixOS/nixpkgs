{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mkbrr";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "mkbrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6T7/HrCXMVun1Q+ZlBSGbV/ct88BVuf/I4KzdER5XGg=";
  };

  vendorHash = "sha256-xvDgEN3FeSDmKtO66+8MLVW0cL9zHijk6XugeWGJxCA=";

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
