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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    tag = "v${version}";
    hash = "sha256-GzDrB0UJxBc2U/JXcJee7dMvlahD2Qqaen14677q+28=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-G9Mm89nb9dJH+vl6YL9mlisD+/wrFiSYnuSuobBon9c=";

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
  versionCheckProgramArg = [ "--version" ];
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
