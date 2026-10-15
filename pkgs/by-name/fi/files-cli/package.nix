{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "files-cli";
  version = "2.15.463";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OG/fMitBklIGAOV5+ghURpWw7NdiQR3eL6tL4fJOo7s=";
  };

  vendorHash = "sha256-p9MQvNZXkvcgKpIGqSNP+hCN2iMLsXplGp3236ZP2O0=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Files.com Command Line App for Windows, Linux, and macOS";
    homepage = "https://developers.files.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "files-cli";
  };

})
