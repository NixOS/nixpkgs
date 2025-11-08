{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "crictty";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "crictty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8I5HsG0fJyp+PEkUPvyrZm587qZ3Yz2jofCmEKGmps=";
  };

  vendorHash = "sha256-B5+F9WXRkJhiafC+jhzZRvHlDH9XBkHQL5kBnrPRUTk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ashish0kumar/crictty/releases/tag/v${finalAttrs.version}";
    description = "Terminal-based cricket scorecard viewer";
    homepage = "https://github.com/ashish0kumar/crictty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashish0kumar ];
    mainProgram = "crictty";
    platforms = lib.platforms.unix;
  };
})
