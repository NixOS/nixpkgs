{ wrapCC, gcc14 }:
wrapCC (
  gcc14.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  }
)
