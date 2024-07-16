{ melpaBuild, llvmPackages }:

melpaBuild {
  pname = "llvm-mode";
  inherit (llvmPackages.llvm) version;

  src = "${llvmPackages.llvm.src}/llvm/utils/emacs";

  meta = {
    inherit (llvmPackages.llvm.meta) homepage license;
    description = "Major mode for the LLVM assembler language";
  };
}
