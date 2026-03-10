{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-enhance";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-enhance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IHtI8wnPLMkqxdBFXqkt6inYMOIqKjdTKdZbTxIhPzo=";
  };

  vendorHash = "sha256-rgql0vsHAzWeubw4EYBu/yPmm2QeADsIeACWsbcWtSk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-enhance/cmd.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    # requires network
    "-skip=TestFullOutput"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/dlvhdr/gh-enhance/releases/tag/${finalAttrs.src.rev}";
    description = "A Blazingly Fast Terminal UI for GitHub Actions";
    homepage = "https://www.gh-dash.dev/enhance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ replicapra ];
    mainProgram = "gh-enhance";
  };
})
