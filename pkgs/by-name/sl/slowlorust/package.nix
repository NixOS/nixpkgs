{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "slowlorust";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MJVL";
    repo = "slowlorust";
    tag = version;
    hash = "sha256-c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoHash = "sha256-L0N7SVUzdTzDXPaS/da4kCKNG2lwS8Mqk1HET2LqSvY=";

  postPatch = ''
    # https://github.com/MJVL/slowlorust/issues/2
    substituteInPlace src/main.rs \
      --replace-fail 'version = "1.0"' 'version = "${version}"'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "Lightweight slowloris (HTTP DoS) tool";
    homepage = "https://github.com/MJVL/slowlorust";
    changelog = "https://github.com/MJVL/slowlorust/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "slowlorust";
  };
}
