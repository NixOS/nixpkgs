{
  lib,
  djgpp_i586,
}:

lib.lowPrio (
  djgpp_i586.override {
    targetArchitecture = "i686";
  }
)
