{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "files-cli";
  version = "2.15.448";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    tag = "v${finalAttrs.version}";
    hash = "sha256-blOBJWst/SYrf/POXM1hNrCr86SM+LBdEVewE0ej1CA=";
  };

  vendorHash = "sha256-7uZNHUWtzH/5p1ZXCY07iP1huPpxz5lQOJc0NXu68kQ=";

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
