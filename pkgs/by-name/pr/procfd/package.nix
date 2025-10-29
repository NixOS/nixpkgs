{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "procfd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "procfd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhnSHtPT9H9CWotwQIA9gFvwgm0PKsmDjQS817PxMw0=";
  };

  cargoHash = "sha256-srFXs+h+ZMXeWRwGQUAqMACJG4ZUgztWr2ff6sRfkU8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Linux lsof replacement to list open file descriptors for processes";
    homepage = "https://github.com/deshaw/procfd";
    license = lib.licenses.bsd3;
    mainProgram = "procfd";
    platforms = lib.platforms.linux;
    teams = with lib.teams; [ deshaw ];
  };
})
