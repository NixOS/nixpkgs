{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gh-dash";
  version = "4.25.2";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3iUBuMvA2Xh7UjTiFNEs3tuZMCnSt/bIhTSEDD92yCU=";
  };

  vendorHash = "sha256-Teu+8jiZE2gZ+0ErKsunhotY9W4Hjg6PAeFkFLgESIk=";

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
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "gh-dash";
  };
})
