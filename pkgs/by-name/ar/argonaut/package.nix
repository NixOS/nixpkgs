{
  buildGoModule,
  lib,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "argonaut";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "darksworm";
    repo = "argonaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNuZ15g57+3b0aE928amQ6I3GObbBZpUjyasVQ6ug7M=";
  };

  vendorHash = "sha256-4AmciHL4CGtEwDAs7eAtjfWlzjoCLXAN2HEatev8gZg=";
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
