{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "files-cli";
  version = "2.15.455";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    tag = "v${finalAttrs.version}";
    hash = "sha256-07Ul3BhO3zpU0Y4w65t/6pITV+x0UyNSTmdgI939GMo=";
  };

  vendorHash = "sha256-KvhI2ZmyBBtTwm+m+LJX95mUPtAh0/dVUtRaBNrlQ6Y=";

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
