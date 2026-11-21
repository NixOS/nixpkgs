{
  buildGoModule,
  lib,
  fetchFromGitHub,
  testers,
  versionCheckHook,
  git,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "argonaut";
  version = "2.20.0";

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];
  src = fetchFromGitHub {
    owner = "darksworm";
    repo = "argonaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RW3GoIwlySQixarsFy5jVejzl7WP7oB9lRmH+OD6SAQ=";
  };

  vendorHash = "sha256-b9Xq7CTEvdwtNtgF9PRKp2HkVNzxm6z+yCmH5ny9Hfc=";
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
