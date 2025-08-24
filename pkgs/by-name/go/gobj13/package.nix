{ wrapCC, gcc13 }:
# Use the same GCC version as the one from stdenv by default
wrapCC (
  gcc13.cc.override {
    name = "gobjc";
    langCC = true;
    langC = true;
    langObjCpp = true;
    langObjC = true;
  }
)