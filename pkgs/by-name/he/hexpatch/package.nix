{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexpatch";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    rev = "v${version}";
    hash = "sha256-UhenCrCVUL6mdEpmTU4e1sIHBS8QXVRtKTMlLah56Zs=";
  };

  cargoHash = "sha256-jWDntqxWsSzfDFxZnVDxh7n/CjFIj+sYMsyX/UXhoaM=";

  nativeBuildInputs = [
    cmake
    python3
  ];

  postFixup = ''
    ln -s $out/bin/hex-patch $out/bin/hexpatch
  '';

  meta = {
    description = "Binary patcher and editor written in Rust with a terminal user interface.";
    longDescription = ''
      HexPatch is a binary patcher and editor with a terminal user interface (TUI),
      capable of disassembling instructions and assembling patches. It supports a
      variety of architectures and file formats, and can edit remote files
      via SSH.
    '';
    homepage = "https://etto48.github.io/HexPatch/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vandrw ];
    mainProgram = "hexpatch";
  };
}
