{
  lib,
  stdenv,
  cmake,
  ninja,
  python3,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kuzu";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "kuzudb";
    repo = "kuzu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7TdSWKJ+tzDZ5ur5U762lz9hBAfldsbhcp21z46Rv6c=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  meta = {
    changelog = "https://github.com/kuzudb/kuzu/releases/tag/v${finalAttrs.version}";
    description = "Embeddable property graph database management system";
    homepage = "https://kuzudb.com/";
    license = lib.licenses.mit;
    mainProgram = "kuzu";
    maintainers = with lib.maintainers; [ sdht0 ];
    platforms = lib.platforms.all;
  };
})
