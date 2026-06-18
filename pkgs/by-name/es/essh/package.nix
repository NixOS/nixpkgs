{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "essh";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "essh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-njBhA3CSTAlWjcgY3y+hvl19By2QGy2tHP8+FxgycIA=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-TlvUdlKnRA/L5oePn+YWum1wy3ktHFuXP5V+nH2QNnc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  checkFlags = [
    "--skip=mock_ssh_server_drives_real_connect_flow_end_to_end"
  ];

  meta = {
    description = "SSH client to manage connections, keys and sessions";
    homepage = "https://github.com/matthart1983/essh";
    changelog = "https://github.com/matthart1983/essh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "essh";
  };
})
