{ wrapCC, gcc16 }:
wrapCC (
  gcc16.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  }
)
