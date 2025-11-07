{
  lib,
  llvmPackages,
  python3,
}:
let
  inherit (llvmPackages) clang-unwrapped;
in
python3.pkgs.buildPythonApplication rec {
  pname = "analyze-build";
  inherit (clang-unwrapped) version;

  format = "other";

  src = clang-unwrapped + "/bin";

  dontUnpack = true;

  dependencies = with python3.pkgs; [
    libscanbuild
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    install "$src/analyze-build" "$out/bin/"
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ clang-unwrapped ])
  ];

  meta = {
    description = "run Clang static analyzer against a project with compilation database";
    homepage = "https://github.com/llvm/llvm-project/tree/llvmorg-${version}/clang/tools/scan-build-py/";
    mainProgram = "scan-build";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = lib.intersectLists python3.meta.platforms clang-unwrapped.meta.platforms;
  };
}
