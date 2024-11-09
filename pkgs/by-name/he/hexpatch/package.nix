{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  python3,
  stdenv,
  gcc,
  llvmPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexpatch";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "Etto48";
    repo = "HexPatch";
    rev = "v${version}";
    hash = "sha256-yyYxRJ+o+Z5z7PmjcFCsahRXZ9JHFmGmituzGTxY6ec=";
  };

  cargoHash = "sha256-bckZtHzgKQow7l2Cg6Xi1oNk13FH2xKe8cbZ/Xj9E04=";

  nativeBuildInputs =
    [
      cmake
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gcc ]
    ++ lib.optionals (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isDarwin) [
      llvmPackages.libclang
    ];

  postFixup = ''
    ln -s $out/bin/hex-patch $out/bin/hexpatch
  '';

  meta = {
    description = "A binary patcher and editor written in Rust with terminal user interface.";
    longDescription = ''
      HexPatch is a binary patcher and editor with terminal user interface (TUI),
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
