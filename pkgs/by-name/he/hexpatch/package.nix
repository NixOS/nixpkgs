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
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    tag = "v${version}";
    hash = "sha256-tVJp8ZFHaHM6Yhty0n5W4ZDKG/L5+8ZcbbTnw2yLEOI=";
  };

  cargoHash = "sha256-oKZjLS4+blGMt3K6in4i7JLqKZ8uWAv/uBFU9VT0Ha8=";

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
    upateScript = nix-update-script { };
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
