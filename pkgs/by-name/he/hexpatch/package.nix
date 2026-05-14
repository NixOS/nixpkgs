{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexpatch";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-72OfAQxQJqiaihSZ0QhKJAsnL0ILkdfwr9k7cSb6Obw=";
  };

  cargoHash = "sha256-8iE9fDereQuQD02hI6UmvOa8JlFyoMZ++4yALKLLPzU=";

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
    changelog = "https://github.com/Etto48/HexPatch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratcornu ];
    mainProgram = "hexpatch";
  };
})
