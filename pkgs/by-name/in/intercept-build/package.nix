{
  lib,
  llvmPackages,
  python3,
}:
let
  inherit (llvmPackages) clang-unwrapped;
in
python3.pkgs.buildPythonApplication rec {
  pname = "intercept-build";
  inherit (clang-unwrapped) version;

  format = "other";

  src = clang-unwrapped + "/bin";

  dontUnpack = true;

  dependencies = with python3.pkgs; [
    libscanbuild
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    install "$src/intercept-build" "$out/bin"
  '';

  meta = {
    description = "intercepts the build process to generate a compilation database";
    homepage = "https://github.com/llvm/llvm-project/tree/llvmorg-${version}/clang/tools/scan-build-py/";
    mainProgram = "intercept-build";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
}
