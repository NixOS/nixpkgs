{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gh-dash";
  version = "4.22.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vfp0AUSNl11w9jo7UeYDt+AdSxPzwPdeX7bWcZUkOGc=";
  };

  vendorHash = "sha256-4AbeoH0l7eIS7d0yyJxM7+woC7Q/FCh0BOJj3d1zyX4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/v4/cmd.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    # requires network
    "-skip=TestFullOutput"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${finalAttrs.src.rev}";
    description = "Github Cli extension to display a dashboard with pull requests and issues";
    homepage = "https://www.gh-dash.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-dash";
  };
})
