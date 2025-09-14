{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "procfd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "procfd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M2VFy7WqvoxgzEpS0qd7nGLRt2pKGZlfU9uUHlwDC7Y=";
  };

  cargoHash = "sha256-YmUzcJ8SM3iwjeDZXWBrDcT793ZyF6QdwxuYDh69xZw=";

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
