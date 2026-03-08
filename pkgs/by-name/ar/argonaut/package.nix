{
  buildGoModule,
  lib,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "argonaut";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "darksworm";
    repo = "argonaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vD7XDgENQWexNNMq41W0eC0snUA+JUZeXIBTCH1lbks=";
  };

  vendorHash = "sha256-xln/WmZbi0+rHqMMHRgt0ar/EaBDNscCsd/NckJZnMw=";
  proxyVendor = true;
  subPackages = [ "cmd/app" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.buildDate=1970-01-01T00:00:00Z"
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  postInstall = ''
    mv $out/bin/app $out/bin/argonaut
  '';

  meta = {
    description = "Keyboard-first terminal UI for Argo CD";
    homepage = "https://github.com/darksworm/argonaut";
    changelog = "https://github.com/darksworm/argonaut/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "argonaut";
    maintainers = with lib.maintainers; [
      ehrenschwan-gh
    ];
  };
})
