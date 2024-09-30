{ melpaBuild, llvmPackages }:

melpaBuild {
  pname = "llvm-mode";
  inherit (llvmPackages.llvm) src version;

  files = ''
    ("llvm/utils/emacs/*.el"
     "llvm/utils/emacs/README")
  '';

  ignoreCompilationError = false;

  meta = {
    inherit (llvmPackages.llvm.meta) homepage license;
    description = "Major mode for the LLVM assembler language";
  };
}
