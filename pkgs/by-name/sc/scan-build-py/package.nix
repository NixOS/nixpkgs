{
  lib,
  llvmPackages,
  python3,
}:
let
  inherit (llvmPackages) clang-unwrapped;
in
python3.pkgs.buildPythonApplication rec {
  pname = "scan-build-py";
  inherit (clang-unwrapped) version;

  format = "other";

  src = clang-unwrapped + "/bin";

  dontUnpack = true;

  dependencies = with python3.pkgs; [
    libscanbuild
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    install "$src/scan-build-py" "$out/bin/scan-build-py"
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ clang-unwrapped ])
  ];

  meta = {
    description = "intercepts the build process to generate a compilation database";
    homepage = "https://github.com/llvm/llvm-project/tree/llvmorg-${version}/clang/tools/scan-build-py/";
    mainProgram = "scan-build-py";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = lib.intersectLists python3.meta.platforms clang-unwrapped.meta.platforms;
  };
}
