{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch";
  version = "0.2.22";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aY8HRKSHLQKjl4b7v5q3SeNMc+GJPnE2XVrEsl+nGR0=";
  };

  cargoHash = "sha256-r36x/I/RaIWFEoDYXf3edpLeqGvEyozhT4EuCTSEe/k=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Minimalist fetch tool for Japanese quotes";
    mainProgram = "kotofetch";
    homepage = "https://github.com/hxpe-dev/kotofetch";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yarn ];
  };
})
