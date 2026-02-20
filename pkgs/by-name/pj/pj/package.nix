{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pj";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "josephschmitt";
    repo = "pj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xorBRRiG4mcXf0QtsYnEkNnEjyTemfNrpkK/aEbkOjQ=";
  };

  vendorHash = "sha256-rya2afSV9Y1hmUZU0wyR9NETBl3TXD/OTHv0zvVl8v8=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast project directory finder that searches filesystems for git repositories";
    homepage = "https://github.com/josephschmitt/pj";
    changelog = "https://github.com/josephschmitt/pj/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josephschmitt ];
    mainProgram = "pj";
  };
})
