{ wrapCC, gcc9 }:
# Use the same GCC version as the one from stdenv by default
wrapCC (
  gcc9.cc.override {
    name = "gobjc";
    langCC = true;
    langC = true;
    langObjCpp = true;
    langObjC = true;
  }
)