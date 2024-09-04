{ wrapCC, gcc49 }:
wrapCC (
  gcc49.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  }
)
