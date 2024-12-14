{ wrapCC, gcc11 }:
wrapCC (
  gcc11.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  }
)
