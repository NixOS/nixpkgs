{ trivialBuild
, llvmPackages
}:

trivialBuild {
  pname = "llvm-mode";
  inherit (llvmPackages.llvm) src version;

  postUnpack = ''
    sourceRoot="$sourceRoot/llvm/utils/emacs"
  '';

  meta = {
    inherit (llvmPackages.llvm.meta) homepage license;
    description = "Major mode for the LLVM assembler language";
  };
}
