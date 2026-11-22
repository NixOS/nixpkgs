{ wrapCC, gcc }:
# Use the same GCC version as the one from stdenv by default
wrapCC (
  gcc.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  }
)
