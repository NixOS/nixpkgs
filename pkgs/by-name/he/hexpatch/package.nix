{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexpatch";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    tag = "v${version}";
    hash = "sha256-Q9OrI48CbC7fVbngKYtQq9IKa6HbdAcT3JcJlmNvH+I=";
  };

  cargoHash = "sha256-LGWIzbzP4+uY+4QL1tdNMLHtvrVGpFtbmVUbmdn8oAI=";

  nativeBuildInputs = [
    cmake
    python3
  ];

  postFixup = ''
    ln -s $out/bin/hex-patch $out/bin/hexpatch
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Binary patcher and editor written in Rust with a terminal user interface";
    longDescription = ''
      HexPatch is a binary patcher and editor with a terminal user interface (TUI),
      capable of disassembling instructions and assembling patches. It supports a
      variety of architectures and file formats, and can edit remote files
      via SSH.
    '';
    homepage = "https://etto48.github.io/HexPatch/";
    changelog = "https://github.com/Etto48/HexPatch/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "hexpatch";
  };
}
